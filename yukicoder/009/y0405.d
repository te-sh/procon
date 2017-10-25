import std.algorithm, std.conv, std.range, std.stdio, std.string;

const digits = ["XII", "I", "II", "III", "IIII", "V", "VI", "VII", "VIII", "IX", "X", "XI"];

version(unittest) {} else
void main()
{
  auto rd = readln.split, s1 = rd[0], t = rd[1].to!int;
  auto t1 = digits.countUntil(s1).to!int;
  auto t2 = ((t1 + t) % 12 + 12) % 12;
  writeln(digits[t2]);
}
