import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), w = rd[0], h = rd[1];
  auto mij = h.iota.map!(_ => readln.split.to!(int[])).array;

  auto vij = new bool[][](h, w);

  bool valid(point p)
  {
    return p.x >= 0 && p.y >= 0 && p.x < w && p.y < h;
  }

  bool wfs(point s)
  {
    auto q = SList!pointsCP(pointsCP(s, point(-1, -1)));
    vij[s.y][s.x] = true;

    while (!q.empty) {
      auto cp = q.front; q.removeFront;
      auto curr = cp.curr, prev = cp.prev;
      foreach (sp; sibPoints) {
        auto np = curr + sp;
        if (valid(np) && np != prev && mij[curr.y][curr.x] == mij[np.y][np.x]) {
          if (vij[np.y][np.x]) return true;
          vij[np.y][np.x] = true;
          q.insertFront(pointsCP(np, curr));
        }
      }
    }
    return false;
  }

  bool calc()
  {
    foreach (i; h.iota)
      foreach (j; w.iota)
        if (!vij[i][j] && wfs(point(j.to!int, i.to!int)))
          return true;

    return false;
  }

  writeln(calc ? "possible" : "impossible");
}

struct pointsCP
{
  point curr;
  point prev;
}

struct Point(T) {
  T x, y;

  point opBinary(string op)(point rhs) {
    static if (op == "+") return point(x + rhs.x, y + rhs.y);
  }
}

alias Point!int point;

const auto sibPoints = [point(-1, 0), point(0, -1), point(1, 0), point(0, 1)];
