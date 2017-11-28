import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto b = new int[][](n, m);
  foreach (i; 0..n) b[i] = readln.chomp.map!(c => cast(int)(c - '0')).array;

  auto a = new int[][](n, m);
  foreach (i; 1..n-1) {
    foreach (j; 1..m-1)
      a[i][j] = b[i-1][j];
    foreach (j; 1..m-1) {
      b[i][j-1] -= a[i][j];
      b[i][j+1] -= a[i][j];
      b[i+1][j] -= a[i][j];
    }
  }

  foreach (i; 0..n) {
    foreach (j; 0..m) write(a[i][j]);
    writeln;
  }
}
