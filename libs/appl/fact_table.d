import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray
import std.base64;
import std.regex;

import factor_ring;

const p = 10 ^^ 9 + 7;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto buffer = new ubyte[](int.sizeof * 5000);
  size_t index = 0;

  auto f = mint(1);
  foreach (i; 1..10^^9+1) {
    f = f * i;
    if (i % 200000 == 0) {
      buffer.write!int(f.toInt, &index);
    }
  }

  auto str = Base64.encode(buffer);
  str = str.replaceAll(regex(r"(.{128})", "g"), "$1\n");
  writeln(str);

  auto buffer2 = Base64.decode(str.replaceAll(regex(r"\n", "g"), ""));
  auto factTable = new int[](5000);
  size_t index2 = 0;
  foreach (i; 0..100)
    factTable[i] = buffer2.peek!int(&index2);
}
