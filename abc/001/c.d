import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), deg = rd[0], dis = rd[1];
  auto dir = calcDir(deg), pow = calcPow(dis);
  writeln(pow == 0 ? "C" : dir, " ", pow);
}

auto calcDir(int deg)
{
  const cd = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
              "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
  return cd[(deg + 112) / 225 % 16];
}

auto calcPow(int dis)
{
  const cd = [  15,   93,  201,  327,  477,  645,
               831, 1029, 1245, 1467, 1707, 1959];
  foreach (int i, cdi; cd)
    if (dis < cdi) return i;
  return 12;
}
