import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto a = readln.split.to!(int[]), n = a.length, k = 3;
  auto b = new BitArray[][](n+1, k+1);
  foreach (i; 0..n+1)
    foreach (j; 0..k+1)
      b[i][j].length = a.sum+1;
  b[0][0][0] = true;

  foreach (i; 0..n)
    foreach (j; 0..k+1) {
      b[i+1][j] |= b[i][j];
      if (j < k) {
        auto c = b[i][j].dup;
        c.lshift(a[i]);
        b[i+1][j+1] |= c;
      }
    }

  writeln(b[n][k].bitsSet.array[$-3]);
}

auto lshift(ref BitArray b, size_t n)
{
  if (n % 64 == 0) {
    if (n > 0) { b <<= 1; b <<= n-1; }
  } else {
    b <<= n;
  }
}
