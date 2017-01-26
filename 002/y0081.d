import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions
import std.bigint;    // BigInt

const dec = BigInt(10) ^^ 10;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto r = BigInt(0);
  foreach (_; n.iota) {
    r += readBigInt;
  }

  if (r < 0) write("-");
  writefln("%d.%010d", r.abs / dec, r.abs % dec);
}

auto readBigInt()
{
  auto s = readln.chomp.split(".");
  if (s.length == 1)
    return BigInt(s[0]) * dec;
  else
    return BigInt(s[0] ~ s[1].leftJustifier(10, '0').to!string);
}
