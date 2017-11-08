import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];
  auto s = readln.chomp;

  struct IH { size_t i; int[26] h; }

  auto ih = new IH[](n-k+1);
  foreach (j; 0..k) ++ih[0].h[s[j]-'a'];

  foreach (i; 1..n-k+1) {
    ih[i].i = i;
    ih[i].h[] = ih[i-1].h[];
    --ih[i].h[s[i-1]-'a'];
    ++ih[i].h[s[i+k-1]-'a'];
  }

  ih.multiSort!("a.h < b.h", "a.i < b.i");

  auto prev = ih[0];
  foreach (i; 1..n-k+1) {
    if (ih[i].h == prev.h) {
      if (ih[i].i - prev.i >= k) {
        writeln("YES");
        return;
      }
    } else {
      prev = ih[i];
    }
  }

  writeln("NO");
}
