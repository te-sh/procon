import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], l = rd1[1];
  auto b = new bool[][](l, n-1);
  foreach (i; 0..l) {
    auto rd2 = readln.chomp;
    foreach (j; 0..n-1) b[i][j] = rd2[j*2+1] == '-';
  }
  auto c = readln.chomp.indexOf('o')/2;

  foreach_reverse (bi; b) {
    if (c > 0 && bi[c-1]) --c;
    else if (c < n-1 && bi[c]) ++c;
  }

  writeln(c+1);
}
