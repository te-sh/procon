import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.uni;       // unicode

version(unittest) {} else
void main()
{
  auto a = readln.chomp;
  auto b = readln.chomp;

  auto isValid(string a)
  {
    return a.all!(c => c.isNumber) && (a == "0" || a[0] != '0') && a.to!int <= 12345;
  }

  writeln(isValid(a) && isValid(b) ? "OK" : "NG");
}
