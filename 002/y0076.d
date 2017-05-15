import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -5

version(unittest) {} else
void main()
{
  auto pi = new real[](7);
  real[] si = [0, 1.0000000000000000, 1.0833333333333333, 1.2569444444444444,
               1.5353009259259260, 1.6915991512345676, 2.0513639724794235];
  foreach (i; 1..6)
    pi[i] = si[i + 1] - iota(1, i).map!(a => pi[a] * si[i - a + 1]).sum - 1;
  pi[6] = real(1) - pi[1..6].sum;

  auto t = readln.chomp.to!size_t;
  auto ni = t.iota.map!(_ => readln.chomp.to!int).array;

  auto maxN = ni.reduce!max;
  auto ei = new real[](maxN + 1);

  foreach (i; 1..maxN+1) {
    ei[i] = 1;
    foreach (j; 1..7)
      if (i > j) ei[i] += pi[j] * ei[i - j];
  }

  foreach (n; ni)
    writefln("%.6f", ei[n]);
}
