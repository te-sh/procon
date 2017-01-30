import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), w = rd[0], h = rd[1];
  auto mij = h.iota.map!(_ => readln.split.to!(int[])).array;

  auto isKadomatsu(point p1, point p2, point p3) {
    auto a1 = mij[p1.y][p1.x], a2 = mij[p2.y][p2.x], a3 = mij[p3.y][p3.x];
    return a1 != a3 && (a2 < a1 && a2 < a3 || a2 > a1 && a2 > a3);
  }

  auto calc() {
    auto vm = new VisitedManager(w, h);
    auto q = DList!qitem(qitem(point(0, 1), point(0, 0), 1),
                         qitem(point(1, 0), point(0, 0), 1));
    while (!q.empty) {
      auto qi = q.front; q.removeFront;

      foreach (sib; sibPoints) {
        auto np = qi.curr + sib;
        if (np.x < 0 || np.x >= w || np.y < 0 || np.y >= h) continue;
        if (vm.visited(np, qi.curr) || !isKadomatsu(np, qi.curr, qi.prev)) continue;
        if (np == point(w - 1, h - 1)) return qi.len + 1;
        vm.visit(np, qi.curr);
        q.insertBack(qitem(np, qi.curr, qi.len + 1));
      }
    }
    return -1;
  }

  writeln(calc);
}

struct qitem {
  point curr, prev;
  int len;
}

class VisitedManager {
  bool[][] buf;
  int w, h;

  this(int w, int h) {
    this.w = w;
    this.h = h;
    this.buf = new bool[][](w * h, w * h);
  }

  int idx(point p) {
    return p.y * this.w + p.x;
  }

  void visit(point curr, point prev) {
    this.buf[idx(curr)][idx(prev)] = true;
  }

  bool visited(point curr, point prev) {
    return this.buf[idx(curr)][idx(prev)];
  }
}

struct Point(T) {
  T x, y;

  point opBinary(string op)(point rhs) {
    static if (op == "+") return point(x + rhs.x, y + rhs.y);
  }
}

alias Point!int point;

const auto sibPoints = [point(-1, 0), point(0, -1), point(1, 0), point(0, 1)];
