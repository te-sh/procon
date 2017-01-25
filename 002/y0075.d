import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto k = readln.chomp.to!int;

  auto eps = real(0.001);

  auto lower(real _, real a) {
    return calcE0(k, a) < a;
  }

  auto r = real(1);
  while (!lower(0, r))
    r *= 2;

  auto m = iota(r / 2, r, eps).assumeSorted!lower.upperBound(0);
  writeln(m.front);
}

auto calcE0(int k, real m)
{
  auto ei = new real[](k);
  foreach_reverse (i; k.iota) {
    ei[i] = 0;
    foreach (j; 1..7) {
      if (i + j > k)
        ei[i] += m;
      else if (i + j == k)
        ei[i] += 0;
      else
        ei[i] += ei[i + j];
    }
    ei[i] = ei[i] / 6 + 1;
  }
  return ei[0];
}
