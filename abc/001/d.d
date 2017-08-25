import std.algorithm, std.conv, std.range, std.stdio, std.string;

const maxB = 24 * 12;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  static b = new int[](maxB+1);

  foreach (_; 0..n) {
    auto rd = readln.chomp.split('-').to!(int[]), t1 = rd[0].toMinute, t2 = rd[1].toMinute;
    t1 = t1 / 5;
    t2 = (t2-1) / 5;
    ++b[t1];
    --b[t2+1];
  }

  foreach (i; 1..maxB+1) b[i] += b[i-1];

  auto inRain = false;
  foreach (i; 0..maxB+1) {
    if (inRain) {
      if (!b[i]) {
        writefln("%04d", (i * 5).toTime);
        inRain = false;
      }
    } else {
      if (b[i]) {
        writef("%04d-", (i * 5).toTime);
        inRain = true;
      }
    }
  }
}

auto toMinute(int t)
{
  return (t / 100) * 60 + t % 100;
}

auto toTime(int m)
{
  return m / 60 * 100 + m % 60;
}
