import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto l = readln.split.to!(int[]);
  auto t = readln.chomp.to!int;
  auto names = new string[](t), p = new int[](t);
  foreach (i; 0..t) {
    auto rd = readln.splitter;
    names[i] = rd.front; rd.popFront();
    auto pi = rd.front[0];
    p[i] = pi == '?' ? -1 : cast(int)(pi-'A');
  }

  int[string] za1;
  auto id1 = 0;
  foreach (name; names.dup.sort().uniq) za1[name] = id1++;

  auto nids = new int[](t);
  foreach (i; 0..t) nids[i] = za1[names[i]];
  auto nnids = za1.length.to!int;

  auto acs = new int[](n), scores = new int[](nnids);
  Score[] vscores;
  foreach (i, nid, pi; lockstep(nids, p)) {
    if (pi == -1) continue;
    acs[pi]++;
    auto pt = 50*l[pi] + 500*l[pi]/(8+2*acs[pi]);
    scores[nid] += pt;
    vscores ~= Score(scores[nid], i);
  }

  int[size_t][int] za2;
  auto id2 = 0;
  foreach (vscore; vscores.sort()) za2[vscore.pt][vscore.i] = id2++;

  auto bt = BiTree!int(vscores.length), lastAc = new size_t[](nnids);
  acs[] = 0; scores[] = 0;
  foreach (i, nid, pi; lockstep(nids, p)) {
    if (pi != -1) {
      if (scores[nid] > 0) bt[za2[scores[nid]][lastAc[nid]]] += -1;
      acs[pi]++;
      auto pt = 50*l[pi] + 500*l[pi]/(8+2*acs[pi]);
      scores[nid] += pt;
      bt[za2[scores[nid]][i]] += 1;
      lastAc[nid] = i;
    } else {
      writeln(bt[za2[scores[nid]][lastAc[nid]]..$]);
    }
  }
}

struct Score
{
  int pt;
  size_t i;

  auto opCmp(Score rhs)
  {
    return pt > rhs.pt ? 1 : pt < rhs.pt ? -1 : i < rhs.i ? 1 : -1;
  }
}

struct BiTree(T)
{
  size_t n;
  T[] buf;

  this(size_t n)
  {
    this.n = n;
    this.buf = new T[](n + 1);
  }

  void opIndexOpAssign(string op: "+")(T val, size_t i)
  {
    if (i > n) {
      n *= 2;
      buf.length = n+1;
    }

    ++i;
    for (; i <= n; i += i & -i)
      buf[i] += val;
  }

  pure T opSlice(size_t r, size_t l) const
  {
    return get(l) - get(r);
  }

  pure size_t opDollar() const { return n; }
  pure T opIndex(size_t i) const { return opSlice(i, i+1); }

private:

  pure T get(size_t i) const
  {
    auto s = T(0);
    for (; i > 0; i -= i & -i)
      s += buf[i];
    return s;
  }
}
