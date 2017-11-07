import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.uni;

version(unittest) {} else
void main()
{
  auto s = readln.chomp.toUpper;
  auto ii = s.indexOf('I'), it = s.lastIndexOf('T');
  writeln(ii >= 0 && it > ii && s[ii+1..it].canFind('C') ? "YES" : "NO");
}
