import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, k = rd1[1].to!long;

  struct AB { int a, b; }
  auto ab = new AB[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int; rd2.popFront();
    auto b = rd2.front.to!int;
    ab[i] = AB(a, b);
  }

  ab.sort!"a.a < b.a";

  auto s = 0L;
  foreach (abi; ab) {
    s += abi.b;
    if (s >= k) {
      writeln(abi.a);
      break;
    }
  }
}
