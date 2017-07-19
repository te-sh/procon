import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.uni;
import std.digest.md;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto t = md5Of(s).toHexString.toLower;
  auto u = md5Of(t).toHexString.toLower;
  writeln(u);
}
