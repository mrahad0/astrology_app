// lib/views/pages/ai_reading/saved_charts_details.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../../data/models/chart_models/saved_chart_model.dart';
import '../../../data/models/chart_models/recent_chart_model.dart';

/// A unified details page that can display either SavedChartModel or RecentChartModel
class SavedChartsDetails extends StatefulWidget {
  final SavedChartModel? savedChart;
  final RecentChartModel? recentChart;

  const SavedChartsDetails({
    super.key, 
    this.savedChart,
    this.recentChart,
  }) : assert(savedChart != null || recentChart != null, 'Either savedChart or recentChart must be provided');

  @override
  State<SavedChartsDetails> createState() => _SavedChartsDetailsState();
}

class _SavedChartsDetailsState extends State<SavedChartsDetails> {
  bool _isDownloading = false;
  bool _isSharing = false;

  // Getters to access data from either model
  String get chartCategory => widget.savedChart?.chartCategory ?? widget.recentChart!.chartCategory;
  String get systemDisplayName => widget.savedChart?.systemDisplayName ?? widget.recentChart!.systemDisplayName;
  String get name => widget.savedChart?.name ?? widget.recentChart!.name;
  String get date => widget.savedChart?.date ?? widget.recentChart!.date;
  String get birthTime => widget.savedChart?.birthTime ?? widget.recentChart!.birthTime;
  String get city => widget.savedChart?.city ?? widget.recentChart!.city;
  String get country => widget.savedChart?.country ?? widget.recentChart!.country;
  String get chartImageUrl => widget.savedChart?.chartImageUrl ?? widget.recentChart!.chartImageUrl;
  String get interpretation => widget.savedChart?.interpretation ?? widget.recentChart!.interpretation;
  String get formattedDate => widget.savedChart?.formattedDate ?? widget.recentChart!.formattedDate;
  int get wordCount => widget.savedChart?.wordCount ?? widget.recentChart!.wordCount;
  String get systemType => widget.savedChart?.systemType ?? widget.recentChart!.systemType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "$chartCategory - $systemDisplayName",
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(20)),
          child: Column(
            children: [
              SizedBox(height: ResponsiveHelper.space(20)),

              // Word Count & Generated Card
              _buildWordCountCard(context),

              SizedBox(height: ResponsiveHelper.space(16)),

              // Chart Image Card
              if (chartImageUrl.isNotEmpty) ...[
                _buildChartImageCard(context),
                SizedBox(height: ResponsiveHelper.space(16)),
              ],

              // Info Card
              _buildInfoCard(),

              SizedBox(height: ResponsiveHelper.space(16)),

              // Interpretation Section
              if (interpretation.isNotEmpty)
                _buildInterpretationCard(),

              SizedBox(height: ResponsiveHelper.space(32)),
            ],
          ),
        ),
      ),
    );
  }

  // Word Count Card
  Widget _buildWordCountCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(20)),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Word Count",
                      style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(12))),
                  SizedBox(height: ResponsiveHelper.space(4)),
                  Text("$wordCount words",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(16),
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Generated",
                      style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(12))),
                  SizedBox(height: ResponsiveHelper.space(4)),
                  Text(formattedDate,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(16),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.space(16)),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _isSharing ? null : () => _shareChart(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(12)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Center(
                      child: _isSharing
                          ? SizedBox(
                              height: ResponsiveHelper.height(20),
                              width: ResponsiveHelper.width(20),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: ResponsiveHelper.width(2),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.share, color: Colors.white, size: ResponsiveHelper.iconSize(18)),
                                SizedBox(width: ResponsiveHelper.space(6)),
                                Text("Share",
                                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.space(12)),
              Expanded(
                child: GestureDetector(
                  onTap: _isDownloading ? null : () => _downloadChart(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(12)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Center(
                      child: _isDownloading
                          ? SizedBox(
                              height: ResponsiveHelper.height(20),
                              width: ResponsiveHelper.width(20),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: ResponsiveHelper.width(2),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.download, color: Colors.white, size: ResponsiveHelper.iconSize(18)),
                                SizedBox(width: ResponsiveHelper.space(6)),
                                Text("Download",
                                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Chart Image Card
  Widget _buildChartImageCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(18)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(20)),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$systemDisplayName Chart",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(18),
                  fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
            child: Image.network(
              chartImageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: ResponsiveHelper.height(300),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: ResponsiveHelper.height(300),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: const Color(0xFF9A3BFF),
                    strokeWidth: ResponsiveHelper.width(4),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: ResponsiveHelper.height(200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported,
                          color: Colors.grey, size: ResponsiveHelper.iconSize(50)),
                      SizedBox(height: ResponsiveHelper.space(8)),
                      Text("Failed to load chart image",
                          style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14))),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Info Card
  _buildInfoCard() {
    // Check if this is a Synastry chart with two profiles
    final isSynastry = chartCategory == 'Synastry';
    
    // Get person 2 data from models if available
    final savedChart = widget.savedChart;
    final recentChart = widget.recentChart;
    
    // Person 2 data for Synastry
    String? person2Name;
    String? person2Date;
    String? person2BirthTime;
    String? person2City;
    String? person2Country;
    
    if (isSynastry) {
      // Use the model's person2 fields
      person2Name = savedChart?.name2 ?? recentChart?.name2;
      person2Date = savedChart?.date2 ?? recentChart?.date2;
      person2BirthTime = savedChart?.birthTime2 ?? recentChart?.birthTime2;
      person2City = savedChart?.city2 ?? recentChart?.city2;
      person2Country = savedChart?.country2 ?? recentChart?.country2;
    }
    
    // Extract person 1 name from combined name for display
    String person1Name = name;
    if (isSynastry && name.contains(' & ')) {
      person1Name = name.split(' & ')[0];
    }
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(18)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(20)),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Info",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(18),
                  fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          
          if (isSynastry && person2Name != null) ...[
            // Synastry: Show both profiles
            Text("Person 1",
                style: TextStyle(
                    color: const Color(0xFF9A3BFF),
                    fontSize: ResponsiveHelper.fontSize(14),
                    fontWeight: FontWeight.w600)),
            SizedBox(height: ResponsiveHelper.space(8)),
            _infoRow("Name:", person1Name.isNotEmpty ? person1Name : '-'),
            _infoRow("Date of Birth:", date.isNotEmpty ? date : "-"),
            _infoRow("Birth Time:", birthTime.isNotEmpty ? birthTime : "-"),
            _infoRow("City:", city.isNotEmpty ? city : "-"),
            _infoRow("Country:", country.isNotEmpty ? country : "-"),
            
            SizedBox(height: ResponsiveHelper.space(16)),
            const Divider(color: Colors.grey),
            SizedBox(height: ResponsiveHelper.space(8)),
            
            Text("Person 2",
                style: TextStyle(
                    color: const Color(0xFF9A3BFF),
                    fontSize: ResponsiveHelper.fontSize(14),
                    fontWeight: FontWeight.w600)),
            SizedBox(height: ResponsiveHelper.space(8)),
            _infoRow("Name:", person2Name.isNotEmpty ? person2Name : '-'),
            _infoRow("Date of Birth:", person2Date?.isNotEmpty == true ? person2Date! : "-"),
            _infoRow("Birth Time:", person2BirthTime?.isNotEmpty == true ? person2BirthTime! : "-"),
            _infoRow("City:", person2City?.isNotEmpty == true ? person2City! : "-"),
            _infoRow("Country:", person2Country?.isNotEmpty == true ? person2Country! : "-"),
            
            SizedBox(height: ResponsiveHelper.space(16)),
            const Divider(color: Colors.grey),
            SizedBox(height: ResponsiveHelper.space(8)),
          ] else ...[
            // Standard: Single person info
            _infoRow("Name:", name.isNotEmpty ? name : "-"),
            _infoRow("Date of Birth:", date.isNotEmpty ? date : "-"),
            _infoRow("Birth Time:", birthTime.isNotEmpty ? birthTime : "-"),
            _infoRow("City:", city.isNotEmpty ? city : "-"),
            _infoRow("Country:", country.isNotEmpty ? country : "-"),
          ],
          
          _infoRow("System:", systemDisplayName),
          _infoRow("Chart Type:", chartCategory),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14))),
          Flexible(
            child: Text(value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(14),
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  // Interpretation Card with Markdown
  Widget _buildInterpretationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(18)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(20)),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$systemDisplayName Interpretation",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(18),
                  fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          MarkdownBody(
            data: interpretation,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14), height: 1.6),
              strong: TextStyle(
                  color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.bold),
              em: TextStyle(
                  color: Colors.white70, fontSize: ResponsiveHelper.fontSize(14), fontStyle: FontStyle.italic),
              h1: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(20),
                  fontWeight: FontWeight.bold),
              h2: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(18),
                  fontWeight: FontWeight.bold),
              h3: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(16),
                  fontWeight: FontWeight.bold),
              listBullet: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
            ),
          ),
        ],
      ),
    );
  }

  // Share functionality - generates PDF and shares
  Future<void> _shareChart() async {
    setState(() => _isSharing = true);
    
    // Allow UI to update before heavy operations
    await Future.delayed(const Duration(milliseconds: 50));
    
    try {
      // Load custom font for Unicode support
      pw.Font? customFont;
      pw.Font? customBoldFont;
      try {
        final regularData = await rootBundle.load('assets/fonts/Manrope-Regular.ttf');
        final boldData = await rootBundle.load('assets/fonts/Manrope-Bold.ttf');
        // Check if font files are valid (real TTF files are typically > 10KB)
        if (regularData.lengthInBytes > 10000 && boldData.lengthInBytes > 10000) {
          customFont = pw.Font.ttf(regularData);
          customBoldFont = pw.Font.ttf(boldData);
        }
      } catch (e) {
        // Fallback to default fonts
      }
      
      // Create PDF document with theme
      final pdf = customFont != null
          ? pw.Document(theme: pw.ThemeData.withFont(base: customFont, bold: customBoldFont ?? customFont))
          : pw.Document();

      // Try to download chart image if available
      pw.MemoryImage? chartImage;
      if (chartImageUrl.isNotEmpty) {
        try {
          final response = await HttpClient().getUrl(Uri.parse(chartImageUrl));
          final httpResponse = await response.close();
          final bytes = await _consolidateHttpClientResponseBytes(httpResponse);
          chartImage = pw.MemoryImage(bytes);
        } catch (e) {
          // Skip if image fails to load
        }
      }

      // Add pages to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              // Title
              pw.Center(
                child: pw.Text(
                  '${chartCategory.toUpperCase()} - ${systemDisplayName.toUpperCase()}',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),

              // User Info Section
              pw.Text(
                'USER INFORMATION',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Name: $name'),
              pw.Text('Date of Birth: $date'),
              pw.Text('Birth Time: $birthTime'),
              pw.Text('City: $city'),
              pw.Text('Country: $country'),
              pw.Text('System: $systemDisplayName'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Chart Image if available
              if (chartImage != null) ...[
                pw.Text(
                  '$systemDisplayName CHART',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Container(
                    width: 300,
                    height: 300,
                    child: pw.Image(chartImage),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 20),
              ],

              // Interpretation Section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.purple50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  'INTERPRETATION',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                interpretation.replaceAll('**', ''),
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 20),

              // Footer
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Generated on: ${DateTime.now().toString().substring(0, 19)}',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
              ),
            ];
          },
        ),
      );

      // Save to temp directory first, then share
      final tempDir = await getTemporaryDirectory();
      final fileName = 'chart_${systemType}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      // Share the PDF file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My Astrology Chart Reading',
      );
    } catch (e) {
      showCustomSnackBar('Failed to share: $e');
    } finally {
      setState(() => _isSharing = false);
    }
  }

  // Download functionality - generates PDF with share dialog
  Future<void> _downloadChart() async {
    setState(() => _isDownloading = true);
    try {
      // Load custom font for Unicode support
      pw.Font? customFont;
      pw.Font? customBoldFont;
      try {
        final regularData = await rootBundle.load('assets/fonts/Manrope-Regular.ttf');
        final boldData = await rootBundle.load('assets/fonts/Manrope-Bold.ttf');
        // Check if font files are valid (real TTF files are typically > 10KB)
        if (regularData.lengthInBytes > 10000 && boldData.lengthInBytes > 10000) {
          customFont = pw.Font.ttf(regularData);
          customBoldFont = pw.Font.ttf(boldData);
        }
      } catch (e) {
        // Fallback to default fonts
      }
      
      // Create PDF document with theme
      final pdf = customFont != null
          ? pw.Document(theme: pw.ThemeData.withFont(base: customFont, bold: customBoldFont ?? customFont))
          : pw.Document();

      // Try to download chart image if available
      pw.MemoryImage? chartImage;
      if (chartImageUrl.isNotEmpty) {
        try {
          final response = await HttpClient().getUrl(Uri.parse(chartImageUrl));
          final httpResponse = await response.close();
          final bytes = await _consolidateHttpClientResponseBytes(httpResponse);
          chartImage = pw.MemoryImage(bytes);
        } catch (e) {
          // Skip if image fails to load
        }
      }

      // Add pages to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              // Title
              pw.Center(
                child: pw.Text(
                  '${chartCategory.toUpperCase()} - ${systemDisplayName.toUpperCase()}',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),

              // User Info Section
              pw.Text(
                'USER INFORMATION',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Name: $name'),
              pw.Text('Date of Birth: $date'),
              pw.Text('Birth Time: $birthTime'),
              pw.Text('City: $city'),
              pw.Text('Country: $country'),
              pw.Text('System: $systemDisplayName'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Chart Image if available
              if (chartImage != null) ...[
                pw.Text(
                  '$systemDisplayName CHART',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Container(
                    width: 300,
                    height: 300,
                    child: pw.Image(chartImage),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 20),
              ],

              // Interpretation Section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.purple50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  'INTERPRETATION',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                interpretation.replaceAll('**', ''),
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 20),

              // Footer
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Generated on: ${DateTime.now().toString().substring(0, 19)}',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
              ),
            ];
          },
        ),
      );

      // Save to temp directory first, then share
      final tempDir = await getTemporaryDirectory();
      final fileName = 'chart_${systemType}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      // Open share dialog so user can save to Downloads or any location
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Astrology Chart Reading PDF',
      );
    } catch (e) {
      showCustomSnackBar('Failed to save PDF: $e');
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  /// Helper to consolidate HTTP response bytes
  Future<Uint8List> _consolidateHttpClientResponseBytes(HttpClientResponse response) async {
    final chunks = <List<int>>[];
    await for (var chunk in response) {
      chunks.add(chunk);
    }
    final totalLength = chunks.fold<int>(0, (sum, chunk) => sum + chunk.length);
    final result = Uint8List(totalLength);
    var offset = 0;
    for (var chunk in chunks) {
      result.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return result;
  }
}

/// Factory constructor to create from SavedChartModel
extension SavedChartsDetailsFromSaved on SavedChartsDetails {
  static SavedChartsDetails fromSavedChart(SavedChartModel chart) {
    return SavedChartsDetails(savedChart: chart);
  }
}

/// Factory constructor to create from RecentChartModel
extension SavedChartsDetailsFromRecent on SavedChartsDetails {
  static SavedChartsDetails fromRecentChart(RecentChartModel chart) {
    return SavedChartsDetails(recentChart: chart);
  }
}