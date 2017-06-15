import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  foreach (i; 0..1000) {
    writefln("%03d", i); stdout.flush();
    auto r = readln.chomp;
    if (r == "unlocked") break;
  }
}
