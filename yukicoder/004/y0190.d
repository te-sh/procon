import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  auto adi = ai.filter!"a < 0".map!"-a".array.sort().array;
  auto ami = ai.filter!"a == 0".array;
  auto awi = ai.filter!"a > 0".array.sort().array;

  writeln(calcDW(adi, ami, awi), " ", calcDW(awi, ami, adi), " ", calcM(adi, ami, awi));
}

auto calcDW(int[] adi, int[] ami, int[] awi)
{
  auto adl = adi.length, aml = ami.length, awl = awi.length;
  auto i = 0, j = 0, rdw = 0;
  while (i < adl && j < awl) {
    if (adi[i] > awi[j]) {
      ++rdw; ++i; ++j;
    } else {
      ++i;
    }
  }
  auto rdm = min(adl - rdw, aml);
  auto rdd = (adl - rdw - rdm) / 2;
  return rdw + rdm + rdd;
}

auto calcM(int[] adi, int[] ami, int[] awi)
{
  auto adl = adi.length, aml = ami.length, awl = awi.length;
  auto i = 0, j = 0, rdw = 0;
  while (i < adl && j < awl) {
    if (adi[i] == awi[j]) {
      ++rdw; ++i; ++j;
    } else if (adi[i] < awi[j]) {
      ++i;
    } else {
      ++j;
    }
  }
  auto rmm = aml / 2;
  return rdw + rmm;
}
