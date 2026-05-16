import 'package:flutter/material.dart';


const kNavy  = Color(0xFF081F2F);
const kGold  = Color(0xFFB68826);
const kGold2 = Color(0xFFD4A030);
const kBg    = Color(0xFFF4F6F8);
const kCard  = Color(0xFFFFFFFF);
const kBody  = Color(0xFF3A3A3A);
const kMuted = Color(0xFF8A8A8A);

// ══════════════════════════════════════════════════════════════════════════════
//  DATA MODELS
// ══════════════════════════════════════════════════════════════════════════════


class BlogSection {
  final String? heading;
  final String body;
  final bool isCallout;

  const BlogSection({this.heading, required this.body, this.isCallout = false});
}

class BlogPost {
  final String id;
  final String title;
  final String excerpt;
  final String date;
  final String imageUrl;
  final String category;
  final String readTime;
  final List<BlogSection> sections;

  const BlogPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.date,
    required this.imageUrl,
    required this.category,
    required this.readTime,
    required this.sections,
  });
}

// ══════════════════════════════════════════════════════════════════════════════
//  POSTS
// ══════════════════════════════════════════════════════════════════════════════

final List<BlogPost> blogPosts = [

  // ── POST 1: TSA ─────────────────────────────────────────────────────────────
  BlogPost(
    id: 'tsa-clearance',
    title: 'TSA Clearance for Flight Training in the USA: Complete Guide for International Students',
    excerpt: 'For any non-U.S. citizen planning to begin flight training in the United States, obtaining clearance from the Transportation Security Administration is a mandatory first step.',
    date: 'April 10, 2026',
    imageUrl: 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/IMG_0666-768x251.jpeg',
    category: 'Security & Compliance',
    readTime: '6 min read',
    sections: [
      BlogSection(
        body: 'For any non-U.S. citizen planning to begin flight training in the United States, obtaining clearance from the Transportation Security Administration is a mandatory first step. This process — commonly referred to as TSA/FTSP approval — ensures that all foreign flight students are properly vetted before receiving aviation training.\n\nIf you skip or misunderstand this step, your training cannot legally start, no matter which school you choose.',
      ),
      BlogSection(
        heading: '✈️  What is TSA Clearance (FTSP)?',
        body: 'The TSA clearance process is part of the Flight Training Security Program (FTSP).\n\n👉  It is required for:\n•  All non-U.S. citizens\n•  Receiving training on aircraft over 12,500 lbs  OR\n•  Initial training for Private Pilot License (PPL) and above\n\nIn simple terms: before you fly, the U.S. government wants to verify your identity and background.',
      ),
      BlogSection(
        heading: '🧭  Who Needs TSA Approval?',
        body: 'You must apply if you are:\n•  A foreign national (even if you live in the U.S.)\n•  Planning to take: PPL, Instrument Rating (IR), Multi-Engine, or Type Rating (e.g., A320)\n\nYou do NOT need TSA if:\n•  You are a U.S. citizen\n•  Or only doing ground school (no flight)',
      ),
      BlogSection(
        heading: '🛠️  Step 1 — Register on TSA FTSP Website',
        body: 'Go to the official FTSP portal and create an account. You will:\n•  Enter personal details\n•  Upload passport information\n•  Choose your flight school\n\n👉  Important: Your flight school must confirm your request.',
      ),
      BlogSection(
        heading: '🛠️  Step 2 — Select Training Category',
        body: 'You must apply under the correct training category:\n•  Category 3 → PPL, IR, CPL (most common)\n•  Category 1 or 2 → Large aircraft (type ratings like Airbus A320)\n\n👉  Each course requires a separate TSA approval.',
      ),
      BlogSection(
        heading: '🛠️  Step 3 — Upload Required Documents',
        body: 'You will need:\n•  Passport copy\n•  Visa (if available)\n•  Photo (passport-style)\n\nMake sure all documents are clear and valid, and that names match exactly.',
      ),
      BlogSection(
        heading: '🛠️  Step 4 — Pay TSA Fees',
        body: '•  Approx. \$130–\$160 USD per application\n•  Paid online via credit card\n\n👉  Non-refundable.',
      ),
      BlogSection(
        heading: '🛠️  Step 5 — Fingerprinting',
        body: 'You must complete biometric fingerprinting.\n\nOptions:\n•  In the USA (after arrival)\n•  Or at approved international locations\n\nThis step is critical for background checks.',
      ),
      BlogSection(
        heading: '🛠️  Step 6 — Wait for TSA Approval',
        body: 'Processing time:\n•  Usually up to 30 days\n•  Sometimes longer depending on case\n\nYou will receive:\n👉  "Permission to Initiate Training"',
      ),
      BlogSection(
        heading: '⚠️  Important Rules You MUST Know',
        body: '❌  You CANNOT start flight training before approval\n❌  You need new TSA approval for each course\n❌  Changing flight school requires an update',
        isCallout: true,
      ),
      BlogSection(
        heading: '🧠  Common Mistakes to Avoid',
        body: '❌  Applying under wrong category\n❌  Uploading unclear documents\n❌  Not coordinating with flight school\n❌  Waiting too late (causes training delays)',
      ),
      BlogSection(
        heading: '🎯  Practical Timeline (Recommended)',
        body: 'Before travel to USA:\n•  Choose flight school\n•  Start TSA application\n\nAfter arrival:\n•  Complete fingerprinting\n•  Receive approval\n•  Start training immediately',
      ),
      BlogSection(
        heading: '🚀  Start Your Training with Confidence',
        body: 'At Cougar Aviation Academy (Florida – USA), we assist all international students step-by-step with TSA application guidance, documentation support, and fast-track preparation.\n\nWe ensure you are approved, ready, and flying without delay.\n\nYour journey to the cockpit starts with the right clearance. ✈️',
        isCallout: true,
      ),
    ],
  ),

  // ── POST 2: Part 61 vs 141 ──────────────────────────────────────────────────
  BlogPost(
    id: 'part-61-vs-141',
    title: 'Part 61 vs Part 141: Comprehensive Differences in U.S. Flight Training',
    excerpt: 'Choosing between Part 61 and Part 141 training under the Federal Aviation Administration is one of the most important decisions any aspiring pilot will make.',
    date: 'April 10, 2026',
    imageUrl: 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/IMG_0665-768x428.jpeg',
    category: 'Training',
    readTime: '7 min read',
    sections: [
      BlogSection(
        body: 'Choosing between Part 61 and Part 141 training under the Federal Aviation Administration is one of the most important decisions any aspiring pilot will make. Both paths lead to the same licenses — Private Pilot, Instrument Rating, Commercial Pilot, and beyond — but they differ significantly in structure, flexibility, cost, and training environment.',
      ),
      BlogSection(
        heading: '✈️  What is Part 61 Training?',
        body: 'Part 61 is the more flexible and commonly used training method. It allows instructors and students to customize the training schedule and pace.\n\nKey Characteristics:\n•  Flexible schedule (ideal for part-time students)\n•  One-on-one instruction\n•  No strict syllabus enforcement\n•  Pay-as-you-go system\n\nExample: A student training under Part 61 can fly 2 times per week — or intensively 5–6 times per week — depending on availability and budget.',
      ),
      BlogSection(
        heading: '🧭  What is Part 141 Training?',
        body: 'Part 141 schools are FAA-approved structured programs with a strict syllabus and oversight.\n\nKey Characteristics:\n•  Fixed training schedule\n•  Approved curriculum by FAA\n•  Stage checks and progress monitoring\n•  Classroom + flight integration\n\nIdeal For: Full-time students, career-focused pilots, students who prefer structured environments.',
      ),
      BlogSection(
        heading: '⚖️  Key Differences (Side-by-Side)',
        body: 'Flexibility:         Part 61 = High  |  Part 141 = Low\nStructure:          Part 61 = Instructor-based  |  Part 141 = FAA-approved syllabus\nSchedule:           Part 61 = Custom  |  Part 141 = Fixed\nCost:               Part 61 = Often lower  |  Part 141 = Often higher\nMin. Hours (PPL):   Part 61 = 40 hrs  |  Part 141 = 35 hrs\nLearning Style:     Part 61 = Self-paced  |  Part 141 = Structured\nIdeal Student:      Part 61 = Flexible/working  |  Part 141 = Full-time career',
      ),
      BlogSection(
        heading: '💰  Cost Differences',
        body: 'Part 61 is usually more affordable because:\n•  No mandatory classroom hours\n•  Pay only for what you fly\n•  Less administrative overhead\n\nPart 141 may be more expensive due to:\n•  Structured programs\n•  Additional staff and facilities\n•  Mandatory ground training\n\n👉  However, Part 141 can sometimes reduce total hours, which may offset cost slightly.',
      ),
      BlogSection(
        heading: '⏱️  Training Time & Efficiency',
        body: 'Part 61:\n•  Can be faster or slower depending on student discipline\n•  Ideal for experienced learners or pilots with prior knowledge\n\nPart 141:\n•  Designed for efficiency\n•  Less deviation from syllabus\n•  Better for beginners who need guidance',
      ),
      BlogSection(
        heading: '🎯  Which One is Better for International Students?',
        body: 'Part 61 Advantages:\n•  Lower cost\n•  Flexible scheduling\n•  Faster adaptation if highly motivated\n\nPart 141 Advantages:\n•  Easier visa alignment (especially F-1 programs)\n•  More recognized structured pathway\n•  Better documentation for progress',
      ),
      BlogSection(
        heading: '🛫  Real-World Insight',
        body: 'Many professional pilots — including airline captains — have trained under Part 61, Part 141, or a combination of both.\n\n👉  The FAA license is the same.\n👉  Airlines do NOT prefer one over the other.\n\nWhat matters most: your flight hours, your skills, and your discipline.',
        isCallout: true,
      ),
      BlogSection(
        heading: '🧠  Strategic Recommendation',
        body: 'Choose Part 61 if:\n•  You want flexibility\n•  You are managing budget\n•  You prefer personalized training\n\nChoose Part 141 if:\n•  You want a structured program\n•  You are a full-time student\n•  You prefer classroom environment',
      ),
      BlogSection(
        heading: '🚀  Start Smart with Cougar Aviation Academy',
        body: 'At Cougar Aviation Academy (Florida – USA), we focus on efficient, flexible, and cost-effective Part 61 training, designed especially for international students who want maximum value and real-world readiness.\n\nWhether your goal is Private Pilot or Airbus A320, we guide you step-by-step toward your aviation career.\n\nTrain smart. Fly global. Become airline-ready. ✈️',
        isCallout: true,
      ),
    ],
  ),

  // ── POST 3: How to Become a Pilot ──────────────────────────────────────────
  BlogPost(
    id: 'how-to-become-a-pilot',
    title: 'How to Become a Pilot in the USA (Step-by-Step Guide)',
    excerpt: 'Becoming a professional pilot in the United States is one of the most structured and rewarding aviation career paths in the world. With its advanced training infrastructure and global recognition of FAA licenses.',
    date: 'April 10, 2026',
    imageUrl: 'https://cougaraviationacademy.com/wp-content/uploads/2026/04/IMG_0662-768x332.jpeg',
    category: 'Career Guide',
    readTime: '10 min read',
    sections: [
      BlogSection(
        body: 'Becoming a professional pilot in the United States is one of the most structured and rewarding aviation career paths in the world. With its advanced training infrastructure, high safety standards, and global recognition of licenses issued by the Federal Aviation Administration, the U.S. offers an ideal environment for aspiring pilots — whether they aim for private flying or a full airline career.',
      ),
      BlogSection(
        heading: 'Step 1 — Understand the Pilot Career Path',
        body: 'Before starting, it\'s important to understand the typical progression:\n\n1.  Private Pilot License (PPL)\n2.  Instrument Rating (IR)\n3.  Commercial Pilot License (CPL)\n4.  Multi-Engine Rating (ME)\n5.  Airline Transport Pilot License (ATPL)\n\nEach stage builds on the previous one, both in knowledge and flight experience.',
      ),
      BlogSection(
        heading: 'Step 2 — Choose the Right Flight School',
        body: 'Selecting a reputable flight school is critical. Many students prefer training in Florida due to:\n•  Excellent weather year-round\n•  High concentration of flight schools\n•  Lower training delays\n\nYou can choose between:\n•  Part 61 schools (flexible, cost-effective)\n•  Part 141 schools (structured, faster progression)\n\nFor international students, ensure the school is authorized to train foreign applicants and complies with TSA requirements.',
      ),
      BlogSection(
        heading: 'Step 3 — Obtain the Appropriate Visa',
        body: 'If you are not a U.S. citizen, you will need a student visa:\n•  M-1 Visa: Common for vocational flight training (PPL, CPL)\n•  F-1 Visa: Used when combined with academic programs (e.g., aviation degrees)\n\nYou must also complete the TSA (Transportation Security Administration) clearance before starting flight training.',
      ),
      BlogSection(
        heading: 'Step 4 — Get Your FAA Medical Certificate',
        body: 'Before flying, you must obtain an FAA medical certificate from an approved Aviation Medical Examiner (AME).\n•  First-Class Medical: Required for airline pilots\n•  Second-Class Medical: For commercial pilots\n•  Third-Class Medical: For private pilots\n\nThis ensures you meet the physical and mental fitness standards required for safe flight operations.',
      ),
      BlogSection(
        heading: 'Step 5 — Start with Private Pilot License (PPL)',
        body: 'The PPL is your first license and allows you to fly for personal use.\n\nRequirements:\n•  Minimum 40 flight hours (typically 50–60 hours in reality)\n•  Ground school training\n•  FAA written exam\n•  Checkride with an examiner\n\nAt this stage, you learn:\n•  Basic flight maneuvers\n•  Navigation\n•  Communication\n•  Safety procedures',
      ),
      BlogSection(
        heading: 'Step 6 — Add Instrument Rating (IR)',
        body: 'The Instrument Rating allows you to fly in low visibility conditions using instruments.\n\nWhy it\'s important:\n•  Essential for airline careers\n•  Improves safety and precision\n\nTraining includes:\n•  Instrument navigation (VOR, ILS, GPS)\n•  Flying without visual reference\n•  Simulator training (FAA-approved AATD like Redbird)',
      ),
      BlogSection(
        heading: 'Step 7 — Obtain Commercial Pilot License (CPL)',
        body: 'The CPL allows you to get paid as a pilot.\n\nRequirements:\n•  Minimum 250 total flight hours\n•  Advanced maneuvers\n•  Complex aircraft operations\n\nAt this stage, you transition from "learning to fly" to "flying professionally."',
      ),
      BlogSection(
        heading: 'Step 8 — Multi-Engine Rating (ME)',
        body: 'Most airlines require experience on multi-engine aircraft.\n\nBenefits:\n•  Higher performance aircraft\n•  Better job opportunities\n•  Essential for airline entry\n\nTraining is typically done on aircraft like the Piper Seneca.',
      ),
      BlogSection(
        heading: 'Step 9 — Build Flight Hours',
        body: 'To qualify for airline jobs, you need to accumulate flight hours (typically 1,500 hours for ATPL).\n\nCommon ways to build hours:\n•  Flight instructor (CFI)\n•  Time building programs\n•  Aerial survey or charter operations',
      ),
      BlogSection(
        heading: 'Step 10 — Achieve Airline Transport Pilot License (ATPL)',
        body: 'The ATPL is the highest level of pilot certification.\n\nRequirements:\n•  1,500 total flight hours (FAA standard)\n•  ATP-CTP course\n•  Written exam\n•  Practical test\n\nOnce completed, you are eligible to work as a First Officer with airlines.',
      ),
      BlogSection(
        heading: 'Step 11 — Type Rating (e.g., Airbus A320)',
        body: 'To fly a specific aircraft like the Airbus A320, you need a type rating.\n\nThis includes:\n•  Simulator training\n•  Systems knowledge\n•  Multi-crew coordination (CRM)\n\nThis is your final step before joining an airline.',
      ),
      BlogSection(
        heading: 'Step 12 — Apply for Airline Jobs',
        body: 'After completing all training:\n•  Prepare a professional CV (ATS-friendly)\n•  Apply to airlines worldwide\n•  Attend interviews and simulator assessments\n\nMany pilots start in regions like:\n•  Middle East\n•  Asia\n•  Africa',
      ),
      BlogSection(
        heading: '✈️  Start Your Journey Today',
        body: 'At Cougar Aviation Academy (Florida – USA), we provide a complete Zero to Hero pilot training program, guiding you step-by-step from beginner to professional airline-ready pilot.\n\nYour cockpit is waiting.',
        isCallout: true,
      ),
    ],
  ),
];