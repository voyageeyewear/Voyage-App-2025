import '../widgets/faq_section.dart';

/// Configuration for the FAQ section.
///
/// To customize:
/// 1. Update questions and answers
/// 2. Modify intro text or footer text
/// 3. Add or remove FAQ items
class FaqConfig {
  /// Intro text shown above FAQ items
  static const String introText =
      'We offer free shipping all over India on all prepaid orders. All international & bulk orders would be charged based on the weight of your products, and your location separately at checkout.';

  /// List of FAQ items
  static const List<FaqItem> faqs = [
    FaqItem(
      question: 'How long will it take to get my order?',
      answer:
          'We ship across PAN India. Orders are dispatched within 24 hours of receipt (except on Sundays and Public Holidays). Shipping costs will apply and will be added at checkout. Delivery times may vary depending on factors such as the chosen shipping method, destination, and product availability. For metropolitan cities, delivery typically takes 3-4 business days. We run discounts and promotions throughout the year, so stay tuned for exclusive deals.',
    ),
    FaqItem(
      question: 'Do you provide Polarised sunglasses?',
      answer:
          'Absolutely! We prioritize the protection of your eyes. All our sunglasses come with 100% UV protection to shield your eyes from harmful sun rays. For polarized sunglasses, check out our POLARIZED section.',
    ),
    FaqItem(
      question: 'What is your return policy?',
      answer: '',
      bulletPoints: [
        'We offer a 3-day free exchange from the date of receipt on all COD/Prepaid orders.',
        'A convenience charge of Rs 200 is applicable for refunds on Prepaid orders.',
        'A credit note will be issued for refunds on COD orders placed on our website.',
        'If the customer arranges to send the order back to our premises on their own, Rs 200 will not be deducted, and the full amount will be refunded.',
        'No refund is applicable if the customer has availed any offer or discount (for Prepaid orders).',
      ],
    ),
    FaqItem(
      question: 'Any question?',
      answer:
          'We hope this FAQ section answers your questions about our sunglasses. For any additional inquiries, feel free to reach out to our customer support team—we\'re here to help.\n\nEmail Us On :\nsupport@voyageeyewear.in',
    ),
  ];

  /// Footer text shown below FAQ items
  static const String footerText =
      'Our customer support is available Monday to Saturday : 11 am 6 pm.\nAverage answer time: 2-6hrs';

  /// Enable/Disable section globally
  static const bool enabled = true;
}

