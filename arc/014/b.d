import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto pre = readln.chomp;
  bool[string] memo;
  memo[pre] = true;

  foreach (i; 0..n-1) {
    auto cur = readln.chomp;
    if (cur in memo || pre[$-1] != cur[0]) {
      writeln(i % 2 ? "LOSE" : "WIN");
      return;
    }
    memo[cur] = true;
    pre = cur;
  }

  writeln("DRAW");
}
