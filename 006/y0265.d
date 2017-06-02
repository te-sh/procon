import std.algorithm, std.conv, std.range, std.stdio, std.string;

const re = r"d\{[1-9x\+\*]\}";

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto d = readln.chomp.to!size_t;
  auto s = readln.chomp;

  long[] calc(ref size_t i)
  {
    auto ai = new long[](d+1);
    auto x = 0, y = 0;

  loop: for (; i < s.length; ++i) {
      switch (s[i]) {
      case 'x':
        ++y;
        break;
      case '0','1','2','3','4','5','6','7','8','9':
        x = s[i] - '0';
        break;
      case '*':
        break;
      case '+':
        if (x == 0 && y > 0) ++ai[y];
        else ai[y] += x;
        x = 0; y = 0;
        break;
      case 'd':
        i += 2;
        auto bi = calc(i);
        auto ci = new long[](d+1);
        foreach (j; 1..d+1)
          ci[j-1] = bi[j] * j.to!int;
        ai[] += ci[];
        break;
      case '}':
        break loop;
      default:
        assert(0);
      }
    }

    if (x == 0 && y > 0) ++ai[y];
    else ai[y] += x;

    return ai;
  }

  size_t i = 0;
  writeln(calc(i).to!(string[]).join(" "));
}
