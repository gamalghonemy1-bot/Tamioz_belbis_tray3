import 'package:flutter/material.dart';
import 'autocad.dart';

void main() => runApp(const BelbeisApp());

class BelbeisApp extends StatelessWidget {
  const BelbeisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مركز تميز بلبيس',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
      ),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const HomeScreen(),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  const MenuItem(this.title, this.icon, this.color);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const items = [
    MenuItem('المقايسة', Icons.calculate, Color(0xFF1565C0)),
    MenuItem('رسومات المشروع', Icons.architecture, Color(0xFF2E7D32)),
    MenuItem('الاستحداث', Icons.add_business, Color(0xFFEF6C00)),
    MenuItem('الحصر', Icons.fact_check, Color(0xFF6A1B9A)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز تميز بلبيس',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, i) {
            final item = items[i];
            return Material(
              color: item.color,
              borderRadius: BorderRadius.circular(20),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => item.title == 'المقايسة'
                        ? const MeqayasaScreen()
                        : item.title == 'رسومات المشروع'
                            ? const DrawingsListScreen()
                            : SectionScreen(item: item),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 56, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(item.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SectionScreen extends StatelessWidget {
  final MenuItem item;
  const SectionScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: item.color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 80, color: item.color),
            const SizedBox(height: 16),
            Text('شاشة ${item.title}', style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}


class BoqItem {
  final String part; // أ = الأعمال الكهربائية، ب = ملحق (تكييف/شبكات/لوحات)
  final int no;
  final String name, unit;
  final double qty;
  const BoqItem(this.part, this.no, this.name, this.unit, this.qty);
  String get id => '$part-$no';
}

const boqItems = <BoqItem>[
  // ===== الجزء أ: مهمات التركيبات الكهربائية =====
  BoqItem('أ', 1, 'كشاف LED بانل مدمج 18 وات', 'عدد', 16),
  BoqItem('أ', 2, 'كشاف SMD HIGH BAY LIGHT ليد 200 وات IP65', 'عدد', 37),
  BoqItem('أ', 3, 'كشاف SMD LED OUTDOOR FLOOD LIGHT 150 وات IP65', 'عدد', 74),
  BoqItem('أ', 4, 'كشاف ديكوري جلوب LED SMD قطر 25 سم', 'عدد', 66),
  BoqItem('أ', 5, 'إضاءة طوارئ LED EXIT SIGN قابلة للشحن', 'عدد', 8),
  BoqItem('أ', 6, 'كشاف LED PANEL بارز 20-25 وات', 'عدد', 128),
  BoqItem('أ', 7, 'كشاف LED PANEL بارز 40-45 وات', 'عدد', 17),
  BoqItem('أ', 8, 'كشاف LED PANEL بارز 60-65 وات', 'عدد', 237),
  BoqItem('أ', 9, 'كشاف LED PANEL بارز 70-75 وات', 'عدد', 111),
  BoqItem('أ', 10, 'كشاف غاطس بالأرض UP LIGHT', 'عدد', 30),
  BoqItem('أ', 11, 'كشاف EARTH SPIKE من الألومنيوم', 'عدد', 100),
  BoqItem('أ', 12, 'كشاف غاطس بدرج السلم STEP LIGHT', 'عدد', 30),
  BoqItem('أ', 13, 'عمود إنارة (بولارد) بطول 1 متر', 'عدد', 30),
  BoqItem('أ', 14, 'عمود إنارة ديكوري ارتفاع 3 متر بذراع واحد', 'عدد', 30),
  BoqItem('أ', 15, 'عمود إنارة ديكوري ارتفاع 3 متر بذراعين', 'عدد', 43),
  BoqItem('أ', 16, 'وحدة إضاءة فانوس ديكوري لإنارة العمود', 'عدد', 86),
  BoqItem('أ', 17, 'مفتاح إنارة سكة واحدة 16 أمبير داخل الحائط', 'عدد', 40),
  BoqItem('أ', 18, 'مفتاح إنارة سكتين 16 أمبير داخل الحائط', 'عدد', 45),
  BoqItem('أ', 19, 'مفتاح إنارة ثلاث سكك 16 أمبير داخل الحائط', 'عدد', 35),
  BoqItem('أ', 20, 'مفتاح إنارة ديفياتير 16 أمبير داخل الحائط', 'عدد', 42),
  BoqItem('أ', 21, 'بريزة شوكو SCHUKO SINGLE SOCKET (16 أمبير - 250 فولت)', 'عدد', 603),
  BoqItem('أ', 22, 'بريزة قوى P+N+E بالأرضي (32 أمبير - 250 فولت) IP44', 'عدد', 7),
  BoqItem('أ', 23, 'مروحة محورية (شفاط) قطر 30 سم', 'عدد', 46),
  BoqItem('أ', 24, 'مروحة سقف 56 بوصة بمفتاح السرعات', 'عدد', 229),
  BoqItem('أ', 25, 'سخان كهربائي سعة (30-35) لتر', 'عدد', 4),
  BoqItem('أ', 26, 'مروحة جدارية 18 بوصة', 'عدد', 24),
  // دوائر التغذية الكهربائية - إنارة
  BoqItem('أ', 27, 'دائرة تغذية (3) مخرج إنارة', 'عدد', 8),
  BoqItem('أ', 28, 'دائرة تغذية (4) مخرج إنارة', 'عدد', 7),
  BoqItem('أ', 29, 'دائرة تغذية (5) مخرج إنارة', 'عدد', 6),
  BoqItem('أ', 30, 'دائرة تغذية (6) مخرج إنارة', 'عدد', 23),
  BoqItem('أ', 31, 'دائرة تغذية (7) مخرج إنارة', 'عدد', 13),
  BoqItem('أ', 32, 'دائرة تغذية (8) مخرج إنارة', 'عدد', 8),
  BoqItem('أ', 33, 'دائرة تغذية (9) مخرج إنارة', 'عدد', 25),
  BoqItem('أ', 34, 'دائرة تغذية (10) مخرج إنارة', 'عدد', 2),
  BoqItem('أ', 35, 'مخرج نقطة مضيئة لإنارة اللافتة الرئيسية للمدرسة', 'عدد', 1),
  // دوائر بريزات
  BoqItem('أ', 36, 'دائرة تغذية مخرج بريزة واحد', 'عدد', 7),
  BoqItem('أ', 37, 'دائرة تغذية (2) مخرج بريزة', 'عدد', 13),
  BoqItem('أ', 38, 'دائرة تغذية (3) مخرج بريزة', 'عدد', 13),
  BoqItem('أ', 39, 'دائرة تغذية (4) مخرج بريزة', 'عدد', 36),
  BoqItem('أ', 40, 'دائرة تغذية (5) مخرج بريزة', 'عدد', 15),
  BoqItem('أ', 41, 'دائرة تغذية (6) مخرج بريزة', 'عدد', 31),
  BoqItem('أ', 42, 'دائرة تغذية (7) مخرج بريزة', 'عدد', 6),
  BoqItem('أ', 43, 'دائرة تغذية (8) مخرج بريزة', 'عدد', 8),
  BoqItem('أ', 44, 'دائرة تغذية (10) مخرج بريزة', 'عدد', 2),
  BoqItem('أ', 45, 'مخرج تكييف 3(1×6) مم2 داخل مواسير PVC بمفتاح تشغيل', 'عدد', 129),
  BoqItem('أ', 46, 'مخرج سخان 3(1×6) مم2 بمفتاح تشغيل', 'عدد', 4),
  BoqItem('أ', 47, 'مخرج مروحة سقف بمفتاح تشغيل', 'عدد', 229),
  BoqItem('أ', 48, 'لوحة تشغيل (ماكينات - هود) 16-40 أمبير MCB ثلاثي', 'عدد', 1),
  BoqItem('أ', 49, 'لوحة التحكم والتشغيل لجهازي تكييف بالتبادل', 'عدد', 2),
  BoqItem('أ', 50, 'دائرة قوى بأسلاك نحاسية 3(1×6) مم2 بمفتاح تشغيل وبريزة صاروخ P+N+E 32 أمبير', 'عدد', 23),
  BoqItem('أ', 51, 'دائرة قوى بأسلاك نحاسية 3(1×6) مم2 بمفتاح تشغيل قاطع ثلاثي 10 ك.أ وبريزة صاروخ 3P+N+E', 'عدد', 13),
  // أرضي
  BoqItem('أ', 52, 'تركيب أرضي مناعي (0.5 أوم للقوى و2 أوم للشبكات) - قضبان CLAD STEEL COPPER', 'مقطوعية', 1),
  BoqItem('أ', 53, 'تركيب أرضي مناعي (بدون التوصيل للوحة الرئيسية)', 'مقطوعية', 1),
  BoqItem('أ', 54, 'صندوق توزيع قوى: علبة صاج لعداد الكهرباء 1.5 مم مجهزة بقاطع حماية', 'عدد', 1),
  // كابل تراي وقواطع
  BoqItem('أ', 55, 'كابل تراي لحمل الكابلات (مجاري كابلات) صاج مجلفن 1.25 مم - 10×40 سم', 'م.ط', 200),
  BoqItem('أ', 56, 'كابل تراي لحمل الكابلات (مجاري كابلات) صاج مجلفن 1.25 مم - 10×50 سم', 'م.ط', 250),
  BoqItem('أ', 57, 'لوحة من قاطع تشغيل أحادي (16-40) أمبير MCB 6 ك.أ ولمبة بيان', 'عدد', 7),
  BoqItem('أ', 58, 'لوحة من قاطع تشغيل ثلاثي (16-40) أمبير MCB 10 ك.أ ولمبات بيان', 'عدد', 1),
  BoqItem('أ', 59, 'قاطع حماية ضد التسرب الأرضي ELCB 1P+N (25) أمبير حساسية 30 مللي', 'عدد', 2),
  BoqItem('أ', 60, 'قاطع أحادي (16-40) أمبير MCB سعة 6 ك.أ', 'عدد', 41),
  BoqItem('أ', 61, 'قاطع ثلاثي (16-40) أمبير MCB سعة 10 ك.أ', 'عدد', 12),
  BoqItem('أ', 62, 'قاطع ثلاثي (50-60) أمبير MCB سعة 10 ك.أ', 'عدد', 1),
  BoqItem('أ', 63, 'قاطع ثلاثي (125-150) أمبير M.C.C.B سعة 25 ك.أ', 'عدد', 3),
  BoqItem('أ', 64, 'قاطع ثلاثي (200-250) أمبير M.C.C.B سعة 25 ك.أ', 'عدد', 1),
  BoqItem('أ', 65, 'قاطع ثلاثي (320-400) أمبير M.C.C.B سعة 36 ك.أ', 'عدد', 1),
  // كابلات (راجع المقاطع مع ملف الـ PDF)
  BoqItem('أ', 66, 'خط تغذية بمليك نحاس معزول PVC - قطاع 1×35 مم2', 'م.ط', 25),
  BoqItem('أ', 67, 'خط تغذية بمليك نحاس معزول PVC - قطاع 1×50 مم2', 'م.ط', 25),
  BoqItem('أ', 68, 'خط تغذية بمليك نحاس معزول PVC - قطاع 1×70 مم2', 'م.ط', 100),
  BoqItem('أ', 69, 'كابل نحاسي ثرموبلاستيك CU PVC/PVC - قطاع 3×4 مم2', 'م.ط', 500),
  BoqItem('أ', 70, 'كابل نحاسي ثرموبلاستيك CU PVC/PVC - قطاع 3×10 مم2', 'م.ط', 150),
  BoqItem('أ', 71, 'كابل نحاسي ثرموبلاستيك CU PVC/PVC - قطاع (4×1×10)+(1×10)', 'م.ط', 600),
  BoqItem('أ', 72, 'كابل نحاسي ثرموبلاستيك CU PVC/PVC - قطاع 3×16 مم2', 'م.ط', 30),
  BoqItem('أ', 73, 'كابل نحاسي ثرموبلاستيك CU PVC/PVC - (4×1×16)+(1×16)', 'م.ط', 105),
  BoqItem('أ', 74, 'كابل نحاسي ثرموبلاستيك CU PVC/PVC - (4×1×25)+(1×16)', 'م.ط', 140),
  BoqItem('أ', 75, 'كابل نحاسي ثرموبلاستيك CU PVC/PVC - 4×35 مم2', 'م.ط', 5),
  BoqItem('أ', 76, 'كابل أرضي ألومنيوم مسلح AL/XLPE/STA/PVC 0.6/1 KV - (3×120+70) مم2', 'م.ط', 225),
  BoqItem('أ', 77, 'كابل أرضي ألومنيوم مسلح AL/XLPE/STA/PVC 0.6/1 KV - (3×240+120) مم2', 'م.ط', 200),
  BoqItem('أ', 78, 'كابلات نحاسية معزولة CU PVC/PVC - (3×35)+(1×16)', 'م.ط', 125),
  BoqItem('أ', 79, 'كابلات نحاسية معزولة CU PVC/PVC', 'م.ط', 225),
  BoqItem('أ', 80, 'كابلات نحاسية معزولة CU PVC/PVC - (3×50)+(1×25)', 'م.ط', 85),
  BoqItem('أ', 81, 'كابلات نحاسية معزولة CU PVC/PVC - (3×120)+(1×70)', 'م.ط', 35),
  BoqItem('أ', 82, 'كابلات نحاسية معزولة CU PVC/PVC - (3×150)+(1×70)', 'م.ط', 35),
  BoqItem('أ', 83, 'كابلات نحاسية معزولة CU PVC/PVC - (3×185)+(1×95)', 'م.ط', 15),
  BoqItem('أ', 84, 'كابل أرضي نحاس مسلح CU/XLPE/STA/PVC 0.6/1 KV - (3×185+95) مم2', 'م.ط', 200),
  BoqItem('أ', 85, 'كابل أرضي نحاس مسلح CU/XLPE/STA/PVC 0.6/1 KV - (3×240+120) مم2', 'م.ط', 100),
  // تليفونات
  BoqItem('أ', 86, 'مخرج تليفون من كابل LSZH CAT6 UTP داخل مواسير بلاستيك مع FACE PLATE', 'عدد', 15),
  BoqItem('أ', 87, 'عدة تليفون ديجيتال مميزة DIGITAL PROPERTY TELEPHONE SET', 'عدد', 1),
  BoqItem('أ', 88, 'عدة تليفون IP للمدير IP DSEK TELEPHONE SET FOR MANAGER', 'عدد', 1),
  BoqItem('أ', 89, 'عدة تليفون IP للموظف IP DSEK TELEPHONE SET FOR EMPLOYER', 'عدد', 13),
  BoqItem('أ', 90, 'سنترال تليفوني IP PABX سعة 4 خط خارجي / 30 خط داخلي', 'عدد', 1),
  BoqItem('أ', 91, 'عمل مسار كابلات الفايبر من البوكس الخارجي حتى غرفة التيار الخفيف', 'م.ط', 100),
  // إنذار الحريق
  BoqItem('أ', 92, 'كاشف حساس للدخان ADDRESSABLE OPTICAL SMOKE DETECTOR', 'عدد', 138),
  BoqItem('أ', 93, 'كاشف حريق متعدد الحساسية ADDRESSABLE MULTI SENSOR DETECTOR', 'عدد', 33),
  BoqItem('أ', 94, 'دائرة تغذية مخرج إنذار حريق بكابلات نحاسية مقاومة للحريق 2×1.5 مم2', 'عدد', 200),
  BoqItem('أ', 95, 'زر تشغيل إنذار يدوي MANUAL CALL POINT GLASS BREAK TYPE ADDRESSABLE', 'عدد', 12),
  BoqItem('أ', 96, 'سارينة إنذار بفلاشر داخلية (مستوى صوتي 85 ديسيبل)', 'عدد', 12),
  BoqItem('أ', 97, 'سارينة إنذار بفلاشر خارجية (مستوى صوتي 115 ديسيبل) IP55', 'عدد', 5),
  BoqItem('أ', 98, 'لوحة إنذار حريق ADDRESSABLE FIRE ALARM CONTROL PANEL سعة 2 لوب', 'عدد', 1),
  BoqItem('أ', 99, 'جهاز اتصال آلي 4 ZONE AUTODIALER', 'عدد', 1),
  BoqItem('أ', 100, 'محطة طاقة شمسية 204 كيلو وات على أسطح المباني (ربط على الشبكة)', 'مقطوعية', 1),

  // ===== الجزء ب: التكييف + شبكة المعلومات + لوحات التوزيع =====
  BoqItem('ب', 1, 'جهاز تكييف هواء اسبليت سعة 18000 وحدة حرارية (2.25 حصان) إنفرتر', 'عدد', 54),
  BoqItem('ب', 2, 'كابل ألياف ضوئية FIBER CABLE MULTIMODE 12 CORE INDOOR', 'م.ط', 150),
  BoqItem('ب', 3, 'لوحة توزيع ألياف FIBER MM PATCH PANEL كاملة', 'عدد', 4),
  BoqItem('ب', 4, 'سويتش CORE SWITCH مع ضمان سنة', 'عدد', 1),
  BoqItem('ب', 5, 'سويتش 24 PORT MANAGED GIGABIT POE SWITCH', 'عدد', 1),
  BoqItem('ب', 6, 'سويتش 24 PORT MANAGED GIGABIT SWITCH', 'عدد', 9),
  BoqItem('ب', 7, 'مخرج معلومات من كابل LSZH CAT6A UTP مع FACE PLATE', 'عدد', 96),
  BoqItem('ب', 8, 'لوحة توزيع باتش بانل 24 PORT CAT6A + منظم كابلات', 'عدد', 8),
  BoqItem('ب', 9, 'كابل باتش 1 متر 1M RJ45 CAT6A LSZH PATCH CORD', 'عدد', 178),
  BoqItem('ب', 10, 'كابل باتش 3 متر 3M RJ45 CAT6A LSZH PATCH CORD', 'عدد', 178),
  BoqItem('ب', 11, 'رك اتصالات معدني 19 بوصة 600×600 مم - 12U', 'عدد', 1),
  BoqItem('ب', 12, 'رك اتصالات معدني 19 بوصة 600×600 مم - 22U', 'عدد', 1),
  BoqItem('ب', 13, 'رك اتصالات معدني 19 بوصة 600×600 مم - 27U', 'عدد', 1),
  BoqItem('ب', 14, 'وحدة احتياطية UPS DOUBLE CONVERSION ONLINE قدرة 3000 فولت أمبير', 'عدد', 1),
  BoqItem('ب', 15, 'وحدة احتياطية UPS DOUBLE CONVERSION ONLINE قدرة 6000 فولت أمبير', 'عدد', 6),
  BoqItem('ب', 16, 'كاميرا مراقبة داخلية 2MP IP INDOOR NETWORK DOME CAMERA', 'عدد', 50),
  BoqItem('ب', 17, 'كاميرا مراقبة خارجية 2MP IP OUTDOOR NETWORK BULLET CAMERA IP66', 'عدد', 14),
  BoqItem('ب', 18, 'مخرج كاميرا مراقبة بكابل CAT6A-UTP', 'عدد', 67),
  BoqItem('ب', 19, 'جهاز تسجيل NVR شبكي 16 CH + POE SWITCH هارد 8TB', 'عدد', 5),
  BoqItem('ب', 20, 'شاشة عرض 40 بوصة HDMI, USB 4K SMART LED TV', 'عدد', 3),
  // لوحات التوزيع (من صاج مسحوب)
  BoqItem('ب', 21, 'لوحة توزيع كهربائية W', 'عدد', 1),
  BoqItem('ب', 22, 'لوحة توزيع كهربائية Z', 'عدد', 1),
  BoqItem('ب', 23, 'لوحة توزيع كهربائية D', 'عدد', 1),
  BoqItem('ب', 24, 'لوحة توزيع كهربائية AC', 'عدد', 1),
  BoqItem('ب', 25, 'لوحة توزيع كهربائية رئيسية B', 'عدد', 1),
  BoqItem('ب', 26, 'لوحة توزيع كهربائية C', 'عدد', 1),
  BoqItem('ب', 27, 'لوحة توزيع كهربائية M.W.W', 'عدد', 1),
  BoqItem('ب', 28, 'لوحة توزيع كهربائية A', 'عدد', 1),
  BoqItem('ب', 29, 'لوحة توزيع كهربائية O', 'عدد', 1),
  BoqItem('ب', 30, 'لوحة توزيع كهربائية ET', 'عدد', 1),
  BoqItem('ب', 31, 'لوحة توزيع كهربائية AC.G,F', 'عدد', 2),
  BoqItem('ب', 32, 'لوحة توزيع كهربائية S', 'عدد', 1),
  BoqItem('ب', 33, 'لوحة توزيع كهربائية D0', 'عدد', 1),
  BoqItem('ب', 34, 'لوحة توزيع كهربائية M.I.W,I.E.W', 'عدد', 2),
  BoqItem('ب', 35, 'لوحة توزيع كهربائية F', 'عدد', 1),
  BoqItem('ب', 36, 'لوحة توزيع كهربائية AC.C', 'عدد', 1),
  BoqItem('ب', 37, 'لوحة توزيع كهربائية AC.G1,G0 S.E.W', 'عدد', 4),
  BoqItem('ب', 38, 'لوحة توزيع كهربائية I.H', 'عدد', 1),
  BoqItem('ب', 39, 'لوحة توزيع كهربائية PV', 'عدد', 1),
  BoqItem('ب', 40, 'لوحة توزيع كهربائية AC.C2,F0,F1,D', 'عدد', 4),
  BoqItem('ب', 41, 'لوحة توزيع كهربائية G', 'عدد', 1),
  BoqItem('ب', 42, 'لوحة توزيع كهربائية S.E.I.L', 'عدد', 1),
  BoqItem('ب', 43, 'لوحة توزيع كهربائية F0', 'عدد', 1),
  BoqItem('ب', 44, 'لوحة توزيع كهربائية AC.M', 'عدد', 1),
  BoqItem('ب', 45, 'لوحة توزيع كهربائية D1', 'عدد', 1),
  BoqItem('ب', 46, 'لوحة توزيع كهربائية EF', 'عدد', 1),
  BoqItem('ب', 47, 'لوحة توزيع كهربائية UC', 'عدد', 1),
  BoqItem('ب', 48, 'لوحة توزيع كهربائية E.L', 'عدد', 1),
  BoqItem('ب', 49, 'لوحة توزيع كهربائية FLC,AC,C0', 'عدد', 2),
  BoqItem('ب', 50, 'لوحة توزيع كهربائية F1', 'عدد', 1),
  BoqItem('ب', 51, 'لوحة توزيع كهربائية CNC', 'عدد', 1),
  BoqItem('ب', 52, 'لوحة توزيع كهربائية A0,G0', 'عدد', 2),
  BoqItem('ب', 53, 'لوحة توزيع كهربائية UF', 'عدد', 1),
  BoqItem('ب', 54, 'لوحة توزيع كهربائية C2,G1', 'عدد', 2),
  BoqItem('ب', 55, 'لوحة توزيع كهربائية EA', 'عدد', 1),
  BoqItem('ب', 56, 'لوحة توزيع كهربائية H1', 'عدد', 1),
  BoqItem('ب', 57, 'لوحة توزيع كهربائية C0', 'عدد', 1),
  BoqItem('ب', 58, 'لوحة توزيع كهربائية A1,B1', 'عدد', 2),
  BoqItem('ب', 59, 'لوحة توزيع كهربائية B0,M0', 'عدد', 2),
  BoqItem('ب', 60, 'لوحة توزيع كهربائية H0', 'عدد', 1),
  BoqItem('ب', 61, 'لوحة توزيع كهربائية D2', 'عدد', 1),
  BoqItem('ب', 62, 'لوحة توزيع كهربائية C1', 'عدد', 1),
  BoqItem('ب', 63, 'لوحة توزيع كهربائية UC1', 'عدد', 1),
  BoqItem('ب', 64, 'لوحة توزيع كهربائية UF1', 'عدد', 1),
  BoqItem('ب', 65, 'لوحة توزيع كهربائية ECO', 'عدد', 1),
  BoqItem('ب', 66, 'لوحة توزيع كهربائية EC1,UC0', 'عدد', 2),
  BoqItem('ب', 67, 'لوحة توزيع كهربائية EA0', 'عدد', 1),
  BoqItem('ب', 68, 'لوحة توزيع كهربائية EC2,UR0', 'عدد', 2),
  BoqItem('ب', 69, 'لوحة توزيع كهربائية UC2', 'عدد', 1),
  BoqItem('ب', 70, 'لوحة توزيع كهربائية EF0', 'عدد', 1),
  BoqItem('ب', 71, 'لوحة توزيع كهربائية EA1,F1', 'عدد', 2),
];

class MeqayasaScreen extends StatefulWidget {
  const MeqayasaScreen({super.key});
  @override
  State<MeqayasaScreen> createState() => _MeqayasaScreenState();
}

class _MeqayasaScreenState extends State<MeqayasaScreen> {
  BoqItem? selected;

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المقايسة'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Autocomplete<BoqItem>(
              displayStringForOption: (o) => '${o.part}-${o.no}  ${o.name}',
              optionsBuilder: (v) {
                final q = v.text.trim().toLowerCase();
                if (q.isEmpty) return boqItems;
                return boqItems.where((o) =>
                    o.name.toLowerCase().contains(q) ||
                    o.id.contains(q) ||
                    o.no.toString() == q);
              },
              optionsViewBuilder: (context, onSelected, options) => Align(
                alignment: Alignment.topRight,
                child: Material(
                  elevation: 4,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 300,
                        maxWidth: MediaQuery.of(context).size.width - 32),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final o = options.elementAt(i);
                        return ListTile(
                          dense: true,
                          title: Text(o.name, maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Text('بند ${o.part}-${o.no}'),
                          onTap: () => onSelected(o),
                        );
                      },
                    ),
                  ),
                ),
              ),
              onSelected: (o) => setState(() => selected = o),
              fieldViewBuilder: (context, ctrl, focus, _) => TextField(
                controller: ctrl,
                focusNode: focus,
                decoration: const InputDecoration(
                  labelText: 'ابحث عن البند (بالاسم أو الرقم)',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (selected != null)
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('بند ${selected!.part}-${selected!.no}',
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text(selected!.name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      const Divider(height: 24),
                      Text('الوحدة: ${selected!.unit}',
                          style: const TextStyle(fontSize: 16)),
                      Text('الكمية: ${_fmt(selected!.qty)}',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
