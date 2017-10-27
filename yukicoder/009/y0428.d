import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

version(unittest) {} else
void main()
{
  auto d = BigInt("1234567891011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798991");
  auto n = readln.chomp.to!int;
  d *= n;
  auto s = d.to!string, ns = s.length;
  if (ns == 190)
    writeln("0.", s);
  else
    writeln(s[0..ns-190], ".", s[ns-190..$]);
}
