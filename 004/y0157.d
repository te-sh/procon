import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

alias Point!int point;
alias sibPoints!int sibs;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), w = rd[0], h = rd[1];
  auto cij = h.iota.map!(_ => readln.chomp).array;

  auto vij = new bool[][](h, w);
  foreach (y; h.iota) vij[y][0] = vij[y][w-1] = true;
  foreach (x; w.iota) vij[0][x] = vij[h-1][x] = true;

  auto wij = new bool[][](h, w);

  auto availableSibs(point p) {
    return sibs.map!(a => p + a)
      .filter!(np => np.x >= 0 && np.y >= 0 && np.x < w && np.y < h);
  }

  auto findEmpty() {
    foreach (y; 1..h-1)
      foreach (x; 1..w-1)
        if (cij[y][x] == '.' && !wij[y][x]) return point(x, y);
    return point(-1, -1);
  }

  auto distanceTo1(point s) {
    auto xij = new bool[][](h, w);
    xij[s.y][s.x] = true;

    point[] pi = [s];
    auto r = 1;
    while (!pi.empty) {
      point[] npi;
      foreach (p; pi) {
        foreach (np; availableSibs(p)) {
          if (wij[np.y][np.x]) return r;
          if (cij[np.y][np.x] != '#' || xij[np.y][np.x]) continue;
          xij[np.y][np.x] = true;
          npi ~= np;
        }
      }
      pi = npi;
      ++r;
    }
    return int.max;
  }

  auto s1 = findEmpty;
  vij[s1.y][s1.x] = wij[s1.y][s1.x] = true;

  auto qi1 = SList!point(s1);
  while (!qi1.empty) {
    auto p = qi1.front; qi1.removeFront;
    foreach (np; availableSibs(p)) {
      if (cij[np.y][np.x] != '.' || vij[np.y][np.x]) continue;
      vij[np.y][np.x] = wij[np.y][np.x] = true;
      qi1.insertFront(np);
    }
  }

  auto s2 = findEmpty;
  vij[s2.y][s2.x] = true;

  auto r = int.max;
  auto qi2 = SList!point(s2);
  while (!qi2.empty) {
    auto p = qi2.front; qi2.removeFront;
    foreach (np; availableSibs(p)) {
      if (vij[np.y][np.x]) continue;
      vij[np.y][np.x] = true;
      if (cij[np.y][np.x] == '#')
        r = min(r, distanceTo1(np));
      else
        qi2.insertFront(np);
    }
  }

  writeln(r);
}

struct Point(T) {
  T x, y;

  auto opBinary(string op: "+")(Point!T rhs) { return Point!T(x + rhs.x, y + rhs.y); }
  auto opBinary(string op: "-")(Point!T rhs) { return Point!T(x - rhs.x, y - rhs.y); }
  auto opBinary(string op: "*")(Point!T rhs) { return x * rhs.x + y * rhs.y; }
  auto opBinary(string op: "*")(T a) { return Point!T(x * a, y * a); }

  T hypot2() { return x ^^ 2 + y ^^ 2; }
}

const auto sibPoints(T) = [Point!T(-1, 0), Point!T(0, -1), Point!T(1, 0), Point!T(0, 1)];
