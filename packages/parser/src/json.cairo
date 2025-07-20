#[derive(Drop, Clone, PartialEq, Debug)]
pub enum JsonValue {
    Object: Array<(ByteArray, JsonValue)>,
    Array: Array<JsonValue>,
    String: ByteArray,
    Number: felt252,
    Bool: bool,
    Null,
}

#[derive(Drop, Clone, PartialEq, Debug)]
pub enum JsonError {
    UnexpectedCharacter,
    UnexpectedEndOfInput,
    InvalidNumber,
    InvalidString,
    InvalidEscapeSequence,
}

#[derive(Drop)]
pub struct JsonParser {
    input: ByteArray,
    position: usize,
}

#[generate_trait]
pub impl JsonParserImpl of JsonParserTrait {
    fn new(input: ByteArray) -> JsonParser {
        JsonParser { input, position: 0 }
    }

    fn parse(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        self.skip_whitespace();
        self.parse_value()
    }

    fn parse_value(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        self.skip_whitespace();

        if self.is_at_end() {
            return Result::Err(JsonError::UnexpectedEndOfInput);
        }

        let current_char = self.current_char()?;

        if current_char == '{' {
            self.parse_object()
        } else if current_char == '[' {
            self.parse_array()
        } else if current_char == '"' {
            let s = self.parse_string()?;
            Result::Ok(JsonValue::String(s))
        } else if current_char == 't' || current_char == 'f' {
            self.parse_bool()
        } else if current_char == 'n' {
            self.parse_null()
        } else if current_char == '-' || (current_char >= '0' && current_char <= '9') {
            self.parse_number()
        } else {
            Result::Err(JsonError::UnexpectedCharacter)
        }
    }

    fn parse_object(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        self.consume_char('{')?;
        self.skip_whitespace();

        let mut object = array![];

        if self.check_char('}') {
            self.advance();
            return Result::Ok(JsonValue::Object(object));
        }

        loop {
            self.skip_whitespace();

            let key = self.parse_string()?;
            self.skip_whitespace();
            self.consume_char(':')?;
            self.skip_whitespace();
            let value = self.parse_value()?;

            object.append((key, value));

            self.skip_whitespace();
            if self.check_char('}') {
                self.advance();
                break;
            }

            self.consume_char(',')?;
        }

        Result::Ok(JsonValue::Object(object))
    }

    fn parse_array(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        self.consume_char('[')?;
        self.skip_whitespace();

        let mut arr = array![];

        if self.check_char(']') {
            self.advance();
            return Result::Ok(JsonValue::Array(arr));
        }

        loop {
            self.skip_whitespace();
            let value = self.parse_value()?;
            arr.append(value);

            self.skip_whitespace();
            if self.check_char(']') {
                self.advance();
                break;
            }

            self.consume_char(',')?;
        }

        Result::Ok(JsonValue::Array(arr))
    }

    fn parse_string(ref self: JsonParser) -> Result<ByteArray, JsonError> {
        self.consume_char('"')?;

        let mut result: ByteArray = Default::default();

        while !self.is_at_end() && !self.check_char('"') {
            let ch = self.current_char()?;

            if ch == '\\' {
                self.advance();
                if self.is_at_end() {
                    return Result::Err(JsonError::InvalidEscapeSequence);
                }

                let escaped = self.current_char()?;
                if escaped == '"' {
                    result.append_byte('"');
                } else if escaped == '\\' {
                    result.append_byte('\\');
                } else if escaped == 'n' {
                    result.append_byte('\n');
                } else if escaped == 't' {
                    result.append_byte('\t');
                } else {
                    return Result::Err(JsonError::InvalidEscapeSequence);
                }
            } else {
                result.append_byte(ch);
            }

            self.advance();
        }

        if self.is_at_end() {
            return Result::Err(JsonError::InvalidString);
        }

        self.consume_char('"')?;
        Result::Ok(result)
    }

    fn parse_number(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        let mut is_negative = false;

        if self.check_char('-') {
            is_negative = true;
            self.advance();
        }

        if self.is_at_end() || !self.is_digit(self.current_char()?) {
            return Result::Err(JsonError::InvalidNumber);
        }

        let mut result: felt252 = 0;
        while !self.is_at_end() && self.is_digit(self.current_char()?) {
            let digit = (self.current_char()? - '0').into();
            result = result * 10 + digit;
            self.advance();
        }

        if is_negative {
            result = -result;
        }

        Result::Ok(JsonValue::Number(result))
    }

    fn parse_bool(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        if self.check_string("true") {
            self.advance_by(4);
            Result::Ok(JsonValue::Bool(true))
        } else if self.check_string("false") {
            self.advance_by(5);
            Result::Ok(JsonValue::Bool(false))
        } else {
            Result::Err(JsonError::UnexpectedCharacter)
        }
    }

    fn parse_null(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        if self.check_string("null") {
            self.advance_by(4);
            Result::Ok(JsonValue::Null)
        } else {
            Result::Err(JsonError::UnexpectedCharacter)
        }
    }

    fn skip_whitespace(ref self: JsonParser) {
        while !self.is_at_end() {
            let ch = self.current_char();
            if ch.is_ok() {
                let c = ch.unwrap();
                if c == ' ' || c == '\t' || c == '\n' || c == '\r' {
                    self.advance();
                } else {
                    break;
                }
            } else {
                break;
            }
        }
    }

    fn current_char(ref self: JsonParser) -> Result<u8, JsonError> {
        if self.is_at_end() {
            Result::Err(JsonError::UnexpectedEndOfInput)
        } else {
            match self.input.at(self.position) {
                Option::Some(ch) => Result::Ok(ch),
                Option::None => Result::Err(JsonError::UnexpectedEndOfInput),
            }
        }
    }

    fn check_char(ref self: JsonParser, expected: u8) -> bool {
        if self.is_at_end() {
            false
        } else {
            match self.input.at(self.position) {
                Option::Some(ch) => ch == expected,
                Option::None => false,
            }
        }
    }

    fn check_string(ref self: JsonParser, expected: ByteArray) -> bool {
        if self.position + expected.len() > self.input.len() {
            return false;
        }

        let mut i = 0;
        while i < expected.len() {
            let input_char = match self.input.at(self.position + i) {
                Option::Some(ch) => ch,
                Option::None => { return false; },
            };
            let expected_char = match expected.at(i) {
                Option::Some(ch) => ch,
                Option::None => { return false; },
            };
            if input_char != expected_char {
                return false;
            }
            i += 1;
        }
        true
    }

    fn consume_char(ref self: JsonParser, expected: u8) -> Result<(), JsonError> {
        if self.check_char(expected) {
            self.advance();
            Result::Ok(())
        } else {
            Result::Err(JsonError::UnexpectedCharacter)
        }
    }

    fn advance(ref self: JsonParser) {
        if !self.is_at_end() {
            self.position += 1;
        }
    }

    fn advance_by(ref self: JsonParser, count: usize) {
        let mut i = 0;
        while i < count && !self.is_at_end() {
            self.advance();
            i += 1;
        };
    }

    fn is_at_end(ref self: JsonParser) -> bool {
        self.position >= self.input.len()
    }

    fn is_digit(self: @JsonParser, ch: u8) -> bool {
        ch >= '0' && ch <= '9'
    }
}

pub fn parse_json(input: ByteArray) -> Result<JsonValue, JsonError> {
    let mut parser = JsonParserImpl::new(input);
    parser.parse()
}
