// lib/features/courses/data/course_detail_data.dart

class CourseDetailData {
  final String id;
  final String shortLabel;
  final String name;
  final String tagline;
  final String description;
  final String duration;
  final String level;
  final String imageUrl;
  final List<String> trainingIncludes;
  final List<String> flightTraining;
  final List<String> faaRequirements;
  final List<String> cougarProgram;
  final List<String> trainingFleet;
  final String graduateNote;

  const CourseDetailData({
    required this.id,
    required this.shortLabel,
    required this.name,
    required this.tagline,
    required this.description,
    required this.duration,
    required this.level,
    required this.imageUrl,
    required this.trainingIncludes,
    required this.flightTraining,
    required this.faaRequirements,
    required this.cougarProgram,
    required this.trainingFleet,
    required this.graduateNote,
  });
}

class CoursesRepository {
  static final List<CourseDetailData> all = [
    const CourseDetailData(
      id: 'ppl',
      shortLabel: 'PPL',
      name: 'Private Pilot License',
      tagline: 'Your first step into the skies',
      description:
      'Qualify as Pilot-in-Command on single-engine aircraft for private operations. '
          'Our structured PPL program is conducted under FAA regulations in Florida, USA, '
          'with experienced instructors and modern aircraft — preparing you for a lifetime of flying.',
      duration: '4 – 6 Months',
      level: 'Beginner',
      imageUrl:
      'https://cougaraviationacademy.com/wp-content/uploads/2025/12/new-1024x576.jpg',
      trainingIncludes: [
        'Aircraft systems and operations',
        'Airspace & regulations',
        'Meteorology',
        'Navigation & GPS operations',
        'Airport operations',
        'Normal & emergency procedures',
        'Cross-country planning',
        'Radio communication (FAA phraseology)',
      ],
      flightTraining: [
        'Dual & solo flights',
        'Takeoffs, landings, and maneuvers',
        'Navigation exercises',
        'Emergency scenarios',
      ],
      faaRequirements: [
        '40+ flight hours',
        'FAA Written Exam',
        'PPL Checkride (oral + practical)',
      ],
      cougarProgram: [
        '60 flight hours',
        '60 ground hours',
      ],
      trainingFleet: [
        'Cessna 172',
        'Piper aircraft (as platform availability)',
        'Certified flight simulators for instrument procedures',
      ],
      graduateNote: 'Students may fly solo after instructor authorization.',
    ),

    const CourseDetailData(
      id: 'ir',
      shortLabel: 'IR',
      name: 'Instrument Rating',
      tagline: 'Fly through clouds, fog & low visibility',
      description:
      'Enable yourself to fly safely in bad weather and low visibility using aircraft '
          'instruments only. The Instrument Rating is your gateway to all-weather operations '
          'and an essential step toward professional aviation.',
      duration: '3 – 4 Months',
      level: 'Intermediate',
      imageUrl:
      'https://cougaraviationacademy.com/wp-content/uploads/2025/12/p1-1024x636.jpg',
      trainingIncludes: [
        'IFR regulations',
        'Holding procedures',
        'Instrument approaches (ILS, RNAV, VOR)',
        'Enroute navigation',
        'Weather analysis',
        'Approach planning',
        'Emergency & abnormal operations',
      ],
      flightTraining: [
        'Flying under simulated and actual IFR conditions',
        'Instrument departures & arrivals',
        'Real-world navigation procedures',
      ],
      faaRequirements: [
        '50 hours Cross-Country PIC time',
        '40 hours Instrument time',
        'FAA Written Exam',
        'Instrument Checkride (oral + practical)',
      ],
      cougarProgram: [
        '50 hours Cross-Country PIC time',
        '50 Instrument flight hours',
        '25 ground hours',
      ],
      trainingFleet: [
        'Cessna 172',
        'Piper aircraft (as platform availability)',
        'Certified flight simulators for instrument procedures',
      ],
      graduateNote:
      'Graduates can fly professionally in poor visibility and weather.',
    ),

    const CourseDetailData(
      id: 'cpl',
      shortLabel: 'CPL',
      name: 'Commercial Pilot License',
      tagline: 'Get paid to do what you love',
      description:
      'The Commercial Pilot License allows you to be paid professionally as a pilot. '
          'This advanced program builds on your prior training, honing precision, decision-making, '
          'and commercial aviation standards required for airline-style operations.',
      duration: '6 – 8 Months',
      level: 'Advanced',
      imageUrl:
      'https://cougaraviationacademy.com/wp-content/uploads/2025/12/p4-1024x636.jpg',
      trainingIncludes: [
        'Advanced aircraft operations',
        'Commercial regulations',
        'Complex aircraft systems',
        'High-performance flying',
        'Precision maneuvers',
        'Airline-style operations',
        'Professional decision making',
      ],
      flightTraining: [
        'Advanced maneuvers',
        'Emergency training',
        'Commercial navigation',
        'Long distance cross-country',
        'Simulator training (where applicable)',
      ],
      faaRequirements: [
        'Minimum 250 total flight hours',
        'FAA Written Exam',
        'CPL Checkride (oral + practical)',
      ],
      cougarProgram: [
        '60 hours time building',
        '30 Multi-Engine flight hours',
        '25 ground hours',
      ],
      trainingFleet: [
        'Cessna 172',
        'Piper aircraft (as platform availability)',
        'Certified flight simulators for instrument procedures',
      ],
      graduateNote: 'Graduate becomes legally employable as a professional pilot.',
    ),

    const CourseDetailData(
      id: 'atp_ctp',
      shortLabel: 'ATP-CTP',
      name: 'ATP Certification Training ',
      tagline: 'The gateway to airline command',
      description:
      'The ATP-CTP is the mandatory first step toward obtaining the highest level of pilot '
          'certification issued by the FAA — the Airline Transport Pilot (ATP) Certificate. '
          'Designed to bridge the gap between general aviation and airline operations, this program '
          'delivers advanced theoretical knowledge combined with high-level simulation training.',
      duration: '2 – 3 Weeks',
      level: 'Professional',
      imageUrl:
      'https://cougaraviationacademy.com/wp-content/uploads/2026/04/IMG_0663.jpeg',
      trainingIncludes: [
        'Advanced aerodynamics and aircraft systems knowledge',
        'Airline operational procedures and standards',
        'Multi-crew coordination (MCC) and CRM',
        'High-altitude operations and weather considerations',
        'Upset Prevention and Recovery Training (UPRT)',
        'Academic classroom or online theoretical instruction',
        'Focus on airline-level concepts and decision-making',
      ],
      flightTraining: [
        'Hands-on training in full-flight simulators (FSTD)',
        'Exposure to real-world airline scenarios',
        'Abnormal situation handling',
        'High-altitude simulator exercises',
      ],
      faaRequirements: [
        'Complies with 14 CFR \$61.156',
        'ATP Multi-Engine (ATM) Knowledge Test eligibility',
        'Progress toward FAA ATP Certificate',
        'Meets airline hiring prerequisites',
      ],
      cougarProgram: [
        'FAA-approved curriculum and training standards',
        'Eligible for VA funding (Veterans Benefits)',
        'Training aligned with real airline operational environments',
      ],
      trainingFleet: [
        'Full-Flight Simulators (FSTD)',
        'Advanced Training Devices (ATD)',
        'Airline-type aircraft systems training',
      ],
      graduateNote: 'Graduate becomes legally employable as a professional airline pilot.',
    ),
  ];

  static CourseDetailData? findById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}