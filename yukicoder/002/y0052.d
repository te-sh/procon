import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  bool[string] buf;
  auto n = s.length;
  auto t = new char[](n);
  
  foreach (j; 0..(1 << n)) {
    auto u = s.dup;
    foreach (i; 0..n) {
      if (bitTest(j, i)) {
        t[i] = u[0];
        u = u[1..$];
      } else {
        t[i] = u[$-1];
        u = u[0..$-1];
      }
    }
    buf[t.to!string] = true;
  }

  writeln(buf.length);
}

bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
