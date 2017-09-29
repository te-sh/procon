import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, n = s.length;
  foreach_reverse(i; 1..n/2) {
    if (s[0..i] == s[i..i*2]) {
      writeln(i*2);
      break;
    }
  }
}
