import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ======================= كتالوج الرسومات =======================
class DrawingInfo {
  final String system; // النظام: الإنارة / القوى / ...
  final String floor; // الدور: الدور الأرضي / الدور الأول العلوي / ...
  final String asset; // مسار الملف
  const DrawingInfo(this.system, this.floor, this.asset);
  String get title => '$system - $floor';
}

// أضف كل رسمة هنا: (النظام، الدور، مسار الملف)
// الملفات توضع في assets/drawings/ وتتسجل في pubspec.yaml
const drawings = <DrawingInfo>[
  DrawingInfo('الإنارة', 'الدور الأرضي', 'assets/drawings/light_ground.dxf'),
  DrawingInfo('الإنارة', 'ميزانين الدور الأرضي', 'assets/drawings/light_mezz.dxf'),
  DrawingInfo('الإنارة', 'الدور الأول العلوي', 'assets/drawings/light_first.dxf'),
  DrawingInfo('الإنارة', 'الدور الثاني العلوي', 'assets/drawings/light_second.dxf'),
  DrawingInfo('القوى', 'الدور الأرضي', 'assets/drawings/power_ground.dxf'),
  DrawingInfo('القوى', 'ميزانين الدور الأرضي', 'assets/drawings/power_mezz.dxf'),
  DrawingInfo('القوى', 'الدور الأول العلوي', 'assets/drawings/power_first.dxf'),
  DrawingInfo('القوى', 'الدور الثاني العلوي', 'assets/drawings/power_second.dxf'),
  DrawingInfo('التكييف', 'الدور الأرضي', 'assets/drawings/ac_ground.dxf'),
  DrawingInfo('التكييف', 'الدور الأول العلوي', 'assets/drawings/ac_first.dxf'),
  DrawingInfo('التكييف', 'الدور الثاني العلوي', 'assets/drawings/ac_second.dxf'),
  DrawingInfo('مكافحة وإنذار الحريق', 'الدور الأرضي', 'assets/drawings/fire_ground.dxf'),
  DrawingInfo('مكافحة وإنذار الحريق', 'الدور الأول العلوي', 'assets/drawings/fire_first.dxf'),
  DrawingInfo('مكافحة وإنذار الحريق', 'الدور الثاني العلوي', 'assets/drawings/fire_second.dxf'),
  DrawingInfo('الداتا', 'الدور الأرضي', 'assets/drawings/data_ground.dxf'),
  DrawingInfo('الداتا', 'الدور الأول العلوي', 'assets/drawings/data_first.dxf'),
  DrawingInfo('الداتا', 'الدور الثاني العلوي', 'assets/drawings/data_second.dxf'),
  DrawingInfo('الكاميرات', 'الدور الأرضي', 'assets/drawings/cam_ground.dxf'),
  DrawingInfo('الكاميرات', 'الدور الأول العلوي', 'assets/drawings/cam_first.dxf'),
  DrawingInfo('الكاميرات', 'الدور الثاني العلوي', 'assets/drawings/cam_second.dxf'),
];

class DrawingsListScreen extends StatefulWidget {
  const DrawingsListScreen({super.key});
  @override
  State<DrawingsListScreen> createState() => _DrawingsListScreenState();
}

class _DrawingsListScreenState extends State<DrawingsListScreen> {
  static const all = 'الكل';
  String system = all;
  String floor = all;

  List<String> _options(String Function(DrawingInfo) pick) {
    final set = <String>[];
    for (final d in drawings) {
      final v = pick(d);
      if (!set.contains(v)) set.add(v);
    }
    return [all, ...set];
  }

  @override
  Widget build(BuildContext context) {
    final systems = _options((d) => d.system);
    final floors = _options((d) => d.floor);
    final result = drawings
        .where((d) =>
            (system == all || d.system == system) &&
            (floor == all || d.floor == floor))
        .toList();

    Widget dropdown(String label, String value, List<String> items,
        ValueChanged<String> onChanged) {
      return Expanded(
        child: DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
              labelText: label, border: const OutlineInputBorder()),
          items: [
            for (final i in items) DropdownMenuItem(value: i, child: Text(i))
          ],
          onChanged: (v) => onChanged(v ?? all),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('رسومات المشروع'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                dropdown('النظام', system, systems, (v) => setState(() => system = v)),
                const SizedBox(width: 12),
                dropdown('الدور', floor, floors, (v) => setState(() => floor = v)),
              ],
            ),
          ),
          Expanded(
            child: result.isEmpty
                ? const Center(child: Text('لا توجد رسمة بهذا النظام والدور'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: result.length,
                    itemBuilder: (context, i) {
                      final d = result[i];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.architecture,
                              color: Color(0xFF2E7D32)),
                          title: Text(d.system),
                          subtitle: Text(d.floor),
                          trailing: const Icon(Icons.chevron_left),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DxfViewerScreen(info: d)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ======================= نتيجة القراءة =======================
class TextItem {
  final double x, y, h, rot;
  final String text, layer;
  final int color;
  const TextItem(this.x, this.y, this.h, this.rot, this.text, this.color, this.layer);
}

class LayerGeom {
  final String name;
  final List<int> colors;
  final List<Float64List> coords; // x,y,x,y,... لكل لون
  final List<Int32List> counts; // عدد نقاط كل خط
  final int total; // عدد الخطوط
  LayerGeom(this.name, this.colors, this.coords, this.counts, this.total);
}

class ParsedDxf {
  final List<LayerGeom> layers;
  final List<TextItem> texts;
  final List<double> bounds; // minX, minY, maxX, maxY
  ParsedDxf(this.layers, this.texts, this.bounds);
}

ParsedDxf parseDxf(Uint8List bytes) => _Parser(bytes).run();

class _Ent {
  final String type;
  final int s;
  int e; // نطاق أزواج الـ group codes
  _Ent(this.type, this.s, this.e);
}

class _Ctx {
  final String? layer;
  final int? color;
  const _Ctx(this.layer, this.color);
}

class _Bucket {
  final List<double> pts = [];
  final List<int> counts = [];
}

class _Parser {
  final Uint8List bytes;
  _Parser(this.bytes);

  late Int32List codes;
  late List<String> vals;
  final Map<String, List<_Ent>> sections = {};
  final Map<String, _Blk> blocks = {};
  final Map<String, List<int>> layers = {}; // name -> [color, off(0/1)]
  final Map<String, Map<int, _Bucket>> buckets = {};
  final List<TextItem> texts = [];

  String? gs(_Ent e, int code) {
    for (int i = e.s; i < e.e; i++) {
      if (codes[i] == code) return vals[i];
    }
    return null;
  }

  double gd(_Ent e, int code, [double d = 0]) {
    final v = gs(e, code);
    if (v == null) return d;
    return double.tryParse(v) ?? d;
  }

  ParsedDxf run() {
    final lines = utf8.decode(bytes, allowMalformed: true).split('\n');
    final n = lines.length ~/ 2;
    codes = Int32List(n);
    vals = List<String>.filled(n, '');
    int cnt = 0;
    for (int li = 0; li + 1 < lines.length; li += 2) {
      final c = int.tryParse(lines[li].trim());
      if (c == null) continue;
      codes[cnt] = c;
      vals[cnt] = lines[li + 1].trim();
      cnt++;
    }

    // تقسيم الأقسام والكيانات
    String? cur;
    _Ent? open;
    int i = 0;
    while (i < cnt) {
      final c = codes[i], v = vals[i];
      if (c == 0 && v == 'SECTION') {
        cur = vals[i + 1];
        sections[cur] = [];
        open = null;
        i += 2;
        continue;
      }
      if (c == 0 && v == 'ENDSEC') {
        cur = null;
        open = null;
        i++;
        continue;
      }
      if (cur != null) {
        if (c == 0) {
          open = _Ent(v, i + 1, i + 1);
          sections[cur]!.add(open);
        } else if (open != null) {
          open.e = i + 1;
        }
      }
      i++;
    }

    // الطبقات
    for (final e in sections['TABLES'] ?? <_Ent>[]) {
      if (e.type == 'LAYER') {
        final name = gs(e, 2);
        if (name == null) continue;
        final c = int.tryParse(gs(e, 62) ?? '7') ?? 7;
        final fl = int.tryParse(gs(e, 70) ?? '0') ?? 0;
        layers[name] = [c.abs(), (c < 0 || (fl & 1) == 1) ? 1 : 0];
      }
    }

    // البلوكات
    _Blk? curBlk;
    for (final e in sections['BLOCKS'] ?? <_Ent>[]) {
      if (e.type == 'BLOCK') {
        curBlk = _Blk(gs(e, 2) ?? '', gd(e, 10), gd(e, 20));
        blocks[curBlk.name] = curBlk;
      } else if (e.type == 'ENDBLK') {
        curBlk = null;
      } else if (curBlk != null) {
        curBlk.ents.add(e);
      }
    }

    draw(sections['ENTITIES'] ?? <_Ent>[], [1, 0, 0, 1, 0, 0], const _Ctx(null, null), 0);

    // حدود الرسمة من الهيدر
    List<double>? b;
    double? x1, y1, x2, y2;
    for (int k = 0; k + 2 < cnt; k++) {
      if (codes[k] == 0 && vals[k] == 'ENDSEC' && x2 != null) break;
      if (codes[k] == 9 && (vals[k] == r'$EXTMIN' || vals[k] == r'$EXTMAX')) {
        final x = double.tryParse(vals[k + 1]);
        final y = double.tryParse(vals[k + 2]);
        if (vals[k] == r'$EXTMIN') {
          x1 = x;
          y1 = y;
        } else {
          x2 = x;
          y2 = y;
        }
      }
    }
    if (x1 != null && y1 != null && x2 != null && y2 != null && x2 > x1 && y2 > y1) {
      b = [x1, y1, x2, y2];
    } else {
      double a = double.infinity, c = double.infinity;
      double d = -double.infinity, f = -double.infinity;
      for (final lm in buckets.values) {
        for (final bk in lm.values) {
          for (int k = 0; k + 1 < bk.pts.length; k += 2) {
            a = math.min(a, bk.pts[k]);
            d = math.max(d, bk.pts[k]);
            c = math.min(c, bk.pts[k + 1]);
            f = math.max(f, bk.pts[k + 1]);
          }
        }
      }
      b = [a, c, d, f];
    }

    final out = <LayerGeom>[];
    buckets.forEach((name, cm) {
      final cols = <int>[];
      final cs = <Float64List>[];
      final ns = <Int32List>[];
      int total = 0;
      cm.forEach((k, v) {
        cols.add(k);
        cs.add(Float64List.fromList(v.pts));
        ns.add(Int32List.fromList(v.counts));
        total += v.counts.length;
      });
      out.add(LayerGeom(name, cols, cs, ns, total));
    });
    return ParsedDxf(out, texts, b);
  }

  // ---------- ألوان ----------
  static int _rgb(int r, int g, int b) => 0xFF000000 | (r << 16) | (g << 8) | b;

  static int aci(int n) {
    switch (n) {
      case 1: return _rgb(255, 0, 0);
      case 2: return _rgb(255, 255, 0);
      case 3: return _rgb(0, 255, 0);
      case 4: return _rgb(0, 255, 255);
      case 5: return _rgb(0, 0, 255);
      case 6: return _rgb(255, 0, 255);
      case 7: return _rgb(255, 255, 255);
      case 8: return _rgb(128, 128, 128);
      case 9: return _rgb(192, 192, 192);
    }
    if (n >= 250 && n <= 255) {
      final g = [51, 91, 132, 173, 214, 255][n - 250];
      return _rgb(g, g, g);
    }
    if (n >= 10 && n <= 249) {
      final h = ((n - 10) ~/ 10) * 15.0;
      final k = (n - 10) % 10;
      final s = k % 2 == 0 ? 1.0 : 0.5;
      final v = [1.0, 1.0, .65, .65, .5, .5, .4, .4, .25, .25][k];
      final c = v * s;
      final x = c * (1 - (((h / 60) % 2) - 1).abs());
      final m = v - c;
      double r, g, b;
      switch ((h / 60).floor() % 6) {
        case 0: r = c; g = x; b = 0; break;
        case 1: r = x; g = c; b = 0; break;
        case 2: r = 0; g = c; b = x; break;
        case 3: r = 0; g = x; b = c; break;
        case 4: r = x; g = 0; b = c; break;
        default: r = c; g = 0; b = x;
      }
      return _rgb(((r + m) * 255).round(), ((g + m) * 255).round(), ((b + m) * 255).round());
    }
    return _rgb(255, 255, 255);
  }

  int? resolveColor(_Ent e, _Ctx ctx) {
    var lay = gs(e, 8) ?? '0';
    if (lay == '0' && ctx.layer != null) lay = ctx.layer!;
    final l = layers[lay] ?? [7, 0];
    if (l[1] == 1) return null;
    final tc = gs(e, 420);
    if (tc != null) {
      final v = int.tryParse(tc) ?? 0xFFFFFF;
      return 0xFF000000 | (v & 0xFFFFFF);
    }
    final c = int.tryParse(gs(e, 62) ?? '256') ?? 256;
    if (c == 256) return aci(l[0]);
    if (c == 0) return ctx.color ?? aci(l[0]);
    return aci(c.abs());
  }

  // ---------- تحويلات ----------
  static List<double> mul(List<double> m, List<double> n) {
    return [
      m[0] * n[0] + m[2] * n[1],
      m[1] * n[0] + m[3] * n[1],
      m[0] * n[2] + m[2] * n[3],
      m[1] * n[2] + m[3] * n[3],
      m[0] * n[4] + m[2] * n[5] + m[4],
      m[1] * n[4] + m[3] * n[5] + m[5],
    ];
  }

  String effLayer(_Ent e, _Ctx ctx) {
    final lay = gs(e, 8) ?? '0';
    return (lay == '0' && ctx.layer != null) ? ctx.layer! : lay;
  }

  void add(List<double> pts, int color, String layer) {
    if (pts.length < 4) return;
    final b = buckets
        .putIfAbsent(layer, () => {})
        .putIfAbsent(color, () => _Bucket());
    b.counts.add(pts.length ~/ 2);
    b.pts.addAll(pts);
  }

  void addPoly(List<List<double>> p, List<double> m, int color, String layer) {
    final out = <double>[];
    for (final q in p) {
      out.add(m[0] * q[0] + m[2] * q[1] + m[4]);
      out.add(m[1] * q[0] + m[3] * q[1] + m[5]);
    }
    add(out, color, layer);
  }

  List<List<double>> arcPts(double cx, double cy, double r, double a0, double a1) {
    while (a1 <= a0) {
      a1 += 2 * math.pi;
    }
    final sw = a1 - a0;
    final n = math.max(4, (sw / (2 * math.pi) * 48).toInt());
    return [
      for (int k = 0; k <= n; k++)
        [cx + r * math.cos(a0 + sw * k / n), cy + r * math.sin(a0 + sw * k / n)]
    ];
  }

  void draw(List<_Ent> ents, List<double> m, _Ctx ctx, int depth) {
    for (final e in ents) {
      final t = e.type;
      if (gs(e, 60) == '1') continue;
      const geo = {'LINE', 'LWPOLYLINE', 'CIRCLE', 'ARC', 'INSERT', 'LEADER', 'DIMENSION'};
      int col = 0;
      final lay0 = effLayer(e, ctx);
      if (geo.contains(t)) {
        final c = resolveColor(e, ctx);
        if (c == null) continue;
        col = c;
      }
      switch (t) {
        case 'LINE':
          addPoly([
            [gd(e, 10), gd(e, 20)],
            [gd(e, 11), gd(e, 21)]
          ], m, col, lay0);
          break;
        case 'LWPOLYLINE':
          _lwpoly(e, m, col, lay0);
          break;
        case 'CIRCLE':
          addPoly(arcPts(gd(e, 10), gd(e, 20), gd(e, 40), 0, 2 * math.pi), m, col, lay0);
          break;
        case 'ARC':
          addPoly(
              arcPts(gd(e, 10), gd(e, 20), gd(e, 40), gd(e, 50) * math.pi / 180,
                  gd(e, 51) * math.pi / 180),
              m, col, lay0);
          break;
        case 'LEADER':
          {
          final pts = <List<double>>[];
          for (int i = e.s; i < e.e; i++) {
            if (codes[i] == 10) {
              pts.add([double.tryParse(vals[i]) ?? 0, 0]);
            } else if (codes[i] == 20 && pts.isNotEmpty) {
              pts.last[1] = double.tryParse(vals[i]) ?? 0;
            }
          }
          addPoly(pts, m, col, lay0);
          }
          break;
        case 'DIMENSION':
          {
          final bl = blocks[gs(e, 2) ?? ''];
          if (bl != null && depth < 6) {
            draw(bl.ents, mul(m, [1, 0, 0, 1, -bl.bx, -bl.by]), _Ctx(lay0, col), depth + 1);
          }
          }
          break;
        case 'INSERT':
          {
          final bl = blocks[gs(e, 2) ?? ''];
          if (bl == null || depth > 6) break;
          final sx = gd(e, 41, 1), sy = gd(e, 42, 1);
          final rot = gd(e, 50) * math.pi / 180;
          final c = math.cos(rot), s = math.sin(rot);
          final ins = [sx * c, sx * s, -sy * s, sy * c, gd(e, 10), gd(e, 20)];
          final mm = mul(m, mul(ins, [1, 0, 0, 1, -bl.bx, -bl.by]));
          final lay = gs(e, 8) ?? '0';
          draw(bl.ents, mm,
              _Ctx((lay != '0' || ctx.layer == null) ? lay : ctx.layer, col), depth + 1);
          }
          break;
        case 'TEXT':
        case 'MTEXT':
          _text(e, m, ctx);
          break;
      }
    }
  }

  void _lwpoly(_Ent e, List<double> m, int col, String layer) {
    final vs = <List<double>>[]; // x, y, bulge
    List<double>? cur;
    for (int i = e.s; i < e.e; i++) {
      final c = codes[i];
      if (c == 10) {
        cur = [double.tryParse(vals[i]) ?? 0, 0, 0];
        vs.add(cur);
      } else if (c == 20 && cur != null) {
        cur[1] = double.tryParse(vals[i]) ?? 0;
      } else if (c == 42 && cur != null) {
        cur[2] = double.tryParse(vals[i]) ?? 0;
      }
    }
    if (vs.length < 2) return;
    final closed = ((int.tryParse(gs(e, 70) ?? '0') ?? 0) & 1) == 1;
    final n = vs.length;
    final rng = closed ? n : n - 1;
    final pts = <List<double>>[];
    for (int i = 0; i < n; i++) {
      final x = vs[i][0], y = vs[i][1], b = vs[i][2];
      if (i == 0) pts.add([x, y]);
      if (i < rng) {
        final x2 = vs[(i + 1) % n][0], y2 = vs[(i + 1) % n][1];
        if (b.abs() > 1e-9) {
          final sw = 4 * math.atan(b);
          final ch = math.sqrt((x2 - x) * (x2 - x) + (y2 - y) * (y2 - y));
          if (ch > 0) {
            final r = ch / (2 * math.sin(sw / 2));
            final mx = (x + x2) / 2, my = (y + y2) / 2;
            final h = r * math.cos(sw / 2);
            final dx = (x2 - x) / ch, dy = (y2 - y) / ch;
            final cx = mx - dy * h, cy = my + dx * h;
            final a0 = math.atan2(y - cy, x - cx);
            final k = math.max(2, (sw.abs() / (math.pi / 12)).toInt());
            for (int j = 1; j <= k; j++) {
              final a = a0 + sw * j / k;
              pts.add([cx + r.abs() * math.cos(a), cy + r.abs() * math.sin(a)]);
            }
            continue;
          }
        }
        pts.add([x2, y2]);
      }
    }
    addPoly(pts, m, col, layer);
  }

  void _text(_Ent e, List<double> m, _Ctx ctx) {
    var s = gs(e, 1) ?? '';
    if (e.type == 'MTEXT') {
      s = s
          .replaceAll(r'\P', '\n')
          .replaceAll(RegExp(r'\\[A-Za-z][^;\\]*;'), '')
          .replaceAll(RegExp(r'[{}]'), '');
    }
    s = s.replaceAll('%%c', 'Ø').replaceAll('%%d', '°').replaceAll('%%p', '±');
    if (s.trim().isEmpty) return;
    final col = resolveColor(e, ctx);
    if (col == null) return;
    double x = gd(e, 10), y = gd(e, 20);
    if (e.type == 'TEXT' &&
        ((int.tryParse(gs(e, 72) ?? '0') ?? 0) != 0 || (int.tryParse(gs(e, 73) ?? '0') ?? 0) != 0) &&
        gs(e, 11) != null) {
      x = gd(e, 11);
      y = gd(e, 21);
    }
    final h = gd(e, 40, 1);
    var rot = gd(e, 50) * math.pi / 180;
    final wx = m[0] * x + m[2] * y + m[4];
    final wy = m[1] * x + m[3] * y + m[5];
    final sc = math.sqrt(m[0] * m[0] + m[1] * m[1]);
    rot += math.atan2(m[1], m[0]);
    texts.add(TextItem(wx, wy, h * sc, rot, s, col, effLayer(e, ctx)));
  }
}

class _Blk {
  final String name;
  final double bx, by;
  final List<_Ent> ents = [];
  _Blk(this.name, this.bx, this.by);
}

// ======================= شاشة العرض =======================
class DxfViewerScreen extends StatefulWidget {
  final DrawingInfo info;
  const DxfViewerScreen({super.key, required this.info});
  @override
  State<DxfViewerScreen> createState() => _DxfViewerScreenState();
}

class _DxfViewerScreenState extends State<DxfViewerScreen> {
  ParsedDxf? data;
  final Map<String, ui.Picture> pics = {};
  final Set<String> hidden = {};
  int version = 0;
  List<TextPainter> painters = [];
  String? error;

  double scale = 1;
  Offset offset = Offset.zero;
  bool fitted = false;
  Size viewSize = Size.zero;

  double _s0 = 1, _fx = 0, _fy = 0, _ox = 0, _oy = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final bd = await rootBundle.load(widget.info.asset);
      final bytes = bd.buffer.asUint8List(bd.offsetInBytes, bd.lengthInBytes);
      final parsed = await compute(parseDxf, bytes);
      final pm = <String, ui.Picture>{};
      for (final lg in parsed.layers) {
        final rec = ui.PictureRecorder();
        final canvas = Canvas(rec);
        for (int i = 0; i < lg.colors.length; i++) {
          final path = Path();
          final c = lg.coords[i];
          final n = lg.counts[i];
          int p = 0;
          for (final cnt in n) {
            path.moveTo(c[p], c[p + 1]);
            for (int k = 1; k < cnt; k++) {
              path.lineTo(c[p + 2 * k], c[p + 2 * k + 1]);
            }
            p += 2 * cnt;
          }
          canvas.drawPath(
              path,
              Paint()
                ..color = Color(lg.colors[i])
                ..style = PaintingStyle.stroke
                ..strokeWidth = 0
                ..isAntiAlias = true);
        }
        pm[lg.name] = rec.endRecording();
      }
      final tps = <TextPainter>[
        for (final t in parsed.texts)
          TextPainter(
            text: TextSpan(text: t.text, style: TextStyle(color: Color(t.color), fontSize: 20)),
            textDirection: TextDirection.ltr,
          )..layout()
      ];
      if (!mounted) return;
      setState(() {
        data = parsed;
        pics
          ..clear()
          ..addAll(pm);
        painters = tps;
      });
    } catch (e) {
      if (mounted) setState(() => error = 'تعذّر فتح الرسمة: $e');
    }
  }

  void _fit() {
    final d = data;
    if (d == null || viewSize.isEmpty) return;
    final b = d.bounds;
    final w = b[2] - b[0], h = b[3] - b[1];
    final s = math.min(viewSize.width / w, viewSize.height / h) * 0.95;
    scale = s;
    offset = Offset(viewSize.width / 2 - (b[0] + b[2]) / 2 * s,
        viewSize.height / 2 + (b[1] + b[3]) / 2 * s);
    fitted = true;
  }

  void _zoomAt(Offset focal, double factor) {
    final ns = (scale * factor).clamp(0.01, 5000.0);
    final wx = (focal.dx - offset.dx) / scale;
    final wy = -(focal.dy - offset.dy) / scale;
    setState(() {
      scale = ns;
      offset = Offset(focal.dx - wx * ns, focal.dy + wy * ns);
    });
  }

  void _showLayers() {
    final list = [...data!.layers]..sort((a, b) => b.total.compareTo(a.total));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.7,
          child: Column(
            children: [
              ListTile(
                title: const Text('الطبقات (Layers)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    TextButton(
                      onPressed: () {
                        hidden.clear();
                        version++;
                        setSheet(() {});
                        setState(() {});
                      },
                      child: const Text('إظهار الكل'),
                    ),
                    TextButton(
                      onPressed: () {
                        hidden.addAll(list.map((l) => l.name));
                        version++;
                        setSheet(() {});
                        setState(() {});
                      },
                      child: const Text('إخفاء الكل'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final l = list[i];
                    return CheckboxListTile(
                      dense: true,
                      title: Text(l.name),
                      subtitle: Text('${l.total} عنصر'),
                      value: !hidden.contains(l.name),
                      onChanged: (v) {
                        if (v == true) {
                          hidden.remove(l.name);
                        } else {
                          hidden.add(l.name);
                        }
                        version++;
                        setSheet(() {});
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.info.title),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          if (data != null)
            IconButton(
              tooltip: 'الطبقات',
              icon: const Icon(Icons.layers),
              onPressed: _showLayers,
            ),
        ],
      ),
      floatingActionButton: data == null
          ? null
          : FloatingActionButton.small(
              onPressed: () => setState(_fit),
              child: const Icon(Icons.fit_screen),
            ),
      body: error != null
          ? Center(child: Text(error!, style: const TextStyle(color: Colors.white)))
          : data == null
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('جاري تحميل الرسمة...', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              : LayoutBuilder(builder: (context, cons) {
                  viewSize = Size(cons.maxWidth, cons.maxHeight);
                  if (!fitted) _fit();
                  return Listener(
                    onPointerSignal: (ev) {
                      if (ev is PointerScrollEvent) {
                        _zoomAt(ev.localPosition, math.exp(-ev.scrollDelta.dy / 300));
                      }
                    },
                    child: GestureDetector(
                      onScaleStart: (d) {
                        _s0 = scale;
                        _fx = d.localFocalPoint.dx;
                        _fy = d.localFocalPoint.dy;
                        _ox = offset.dx;
                        _oy = offset.dy;
                      },
                      onScaleUpdate: (d) {
                        final ns = (_s0 * d.scale).clamp(0.01, 5000.0);
                        final wx = (_fx - _ox) / _s0;
                        final wy = -(_fy - _oy) / _s0;
                        setState(() {
                          scale = ns;
                          offset = Offset(d.localFocalPoint.dx - wx * ns,
                              d.localFocalPoint.dy + wy * ns);
                        });
                      },
                      child: ClipRect(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _DxfPainter(
                              [for (final e in pics.entries) if (!hidden.contains(e.key)) e.value],
                              data!.texts, painters, hidden, version, scale, offset),
                        ),
                      ),
                    ),
                  );
                }),
    );
  }
}

class _DxfPainter extends CustomPainter {
  final List<ui.Picture> pictures;
  final List<TextItem> texts;
  final List<TextPainter> painters;
  final Set<String> hidden;
  final int version;
  final double scale;
  final Offset offset;
  _DxfPainter(this.pictures, this.texts, this.painters, this.hidden,
      this.version, this.scale, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale, -scale);
    for (final p in pictures) {
      canvas.drawPicture(p);
    }
    canvas.restore();

    for (int i = 0; i < texts.length; i++) {
      final t = texts[i];
      final fs = t.h * scale;
      if (fs < 5) continue;
      if (hidden.contains(t.layer)) continue;
      final px = offset.dx + t.x * scale;
      final py = offset.dy - t.y * scale;
      if (px < -200 || py < -200 || px > size.width + 200 || py > size.height + 200) continue;
      final tp = painters[i];
      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(-t.rot);
      final k = fs / 20;
      canvas.scale(k, k);
      tp.paint(canvas, Offset(0, -tp.height));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _DxfPainter old) =>
      old.scale != scale || old.offset != offset || old.version != version;
}
