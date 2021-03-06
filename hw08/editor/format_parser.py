
from typing import Union, List
from lexer import TokenBuffer, SPECIALS
from scheme_exceptions import ParseError


class FormatList():

    def __init__(self, contents: List['Formatted'], last: 'Formatted', comments: List[str], close_paren, allow_inline, prefix: str = ''):
        self.contents = contents
        self.last = last
        self.comments = comments
        self.contains_comment = any(
            ((x.contains_comment or x.comments) for x in contents))
        self.allow_inline = (allow_inline and (len(comments) <= 1))
        self.open_paren = ('(' if (close_paren == ')') else '[')
        self.close_paren = close_paren
        self.prefix = prefix

    def __repr__(self):
        return str(self.__dict__)


class FormatAtom():

    def __init__(self, value: str, comments: List[str] = None, allow_inline=True):
        self.value = value
        self.comments = (comments if comments else [])
        self.contains_comment = False
        self.allow_inline = (allow_inline and (
            (not comments) or (len(comments) <= 1)))
        self.prefix = ''

    def __repr__(self):
        return str(self.__dict__)


Formatted = Union[(FormatList, FormatAtom)]


def get_expression(buffer: TokenBuffer) -> Formatted:
    token = buffer.pop_next_token()
    comments = []
    if ((token == '#') and (not buffer.done) and (buffer.get_next_token() == '[')):
        buffer.pop_next_token()
        out = FormatAtom((('#[' + buffer.pop_next_token().value) + ']'))
        buffer.pop_next_token()
    elif (token in SPECIALS):
        comments = token.comments
        if (token in ('(', '[')):
            out = get_rest_of_list(buffer, (')' if (token == '(') else ']'))
        elif (token in ("'", '`')):
            out = get_expression(buffer)
            out.prefix = token.value
        elif (token == ','):
            if (buffer.get_next_token() == '@'):
                buffer.pop_next_token()
                out = get_expression(buffer)
                out.prefix = ',@'
            else:
                out = get_expression(buffer)
                out.prefix = token.value
        elif (token == '"'):
            out = FormatAtom((('"' + buffer.pop_next_token().value) + '"'))
            buffer.pop_next_token()
        else:
            raise ParseError(
                ''.join(["Unexpected token: '", '{}'.format(token), "'"]))
    else:
        if (token.value.lower() == 'true'):
            token.value = '#t'
        elif (token.value.lower() == 'false'):
            token.value = '#f'
        out = FormatAtom(token.value)
    out.comments = (comments + buffer.tokens[(buffer.i - 1)].comments)
    out.allow_inline = (
        token.comments_inline and buffer.tokens[(buffer.i - 1)].comments_inline)
    return out


def get_rest_of_list(buffer: TokenBuffer, end_paren: str):
    out = []
    last = None
    while ((buffer.get_next_token() != end_paren) and (buffer.get_next_token() != '.')):
        out.append(get_expression(buffer))
    if (buffer.get_next_token() == '.'):
        buffer.pop_next_token()
        last = get_expression(buffer)
    if (buffer.get_next_token() != end_paren):
        raise ParseError(
            'Only one expression may follow a dot in a dotted list.')
    buffer.pop_next_token()
    return FormatList(out, last, [], end_paren, True)
