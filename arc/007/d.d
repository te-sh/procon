import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx
import std.bigint;    // BigInt

version(unittest) {} else
void main()
{
  auto c = readln.chomp;

  auto re = ctRegex!(`^(\d0*)(\d*)$`);

  if (c[0] == '0') c = "1" ~ c;
  auto m = c.matchFirst(re);

  auto a1s = m[1], a1 = BigInt(a1s);
  c = m[2];

  if (c.empty) {
    writeln(a1, " ", 1);
    return;
  }

 loop: foreach (i2; 0..c.length) {
    auto a2 = BigInt(c[0..i2+1]);
    auto s = c[i2+1..$];
    auto d = a2 - a1;
    if (d <= 0) continue;

    auto an = a2;
    while (!s.empty) {
      an += d;
      auto t = an.to!string;
      auto l = min(s.length, t.length);
      if (s[0..l] != t[0..l]) continue loop;
      s = s[l..$];
    }

    writeln(a1, " ", d);
    return;
  }

  if (c.length < a1s.length && c == a1s[0..c.length]) {
    writeln(a1, " ", 1);
  } else {
    for (;;) {
      c ~= '0';
      auto a2 = BigInt(c), d = a2 - a1;
      if (d > 0) {
        writeln(a1, " ", a2-a1);
        return;
      }
    }
  }
}
