import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, a = rd1[1].to!int-1;
  auto k = BigInt(readln.chomp);
  auto b = readln.split.map!(to!int).map!"a-1".array;

  auto l = [a], c = a, v = new ptrdiff_t[](n), p = 0;
  v[] = -1;
  while (v[c] == -1) {
    v[c] = p++;
    c = b[c];
    l ~= c;
  }

  auto s1 = v[c], s2 = p - s1;
  if (k < s1) writeln(l[k.to!int]+1);
  else        writeln(l[s1 + (k - s1) % s2]+1);
}
