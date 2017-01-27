import std.algorithm, std.conv, std.range, std.stdio, std.string;

const auto period = 2800;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  auto wi = createTable();
  auto d = (n - 2014) / period, m = (n - 2014) % period + 1;
  writeln(d * wi.count!"a == 0" + wi[0..m].count!"a == 0" - 1);
}

auto createTable()
{
  auto wi = new int[](period);
  foreach (i; 1..period) {
    wi[i] = (wi[i - 1] + 365 + ((i + 2014).isLeap ? 1 : 0)) % 7;
  }
  return wi;
}

auto isLeap(int y)
{
  return y % 4 == 0 && (y % 100 != 0 || y % 400 == 0);
}
