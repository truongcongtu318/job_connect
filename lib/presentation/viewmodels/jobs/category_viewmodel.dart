import 'package:job_connect/data/repositories/job_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_viewmodel.g.dart';

@riverpod
class CategoryViewModel extends _$CategoryViewModel {
  late final JobRepository _repository;

  @override
  Future<List<String>> build() async {
    _repository = JobRepository();
    return _fetchCategories();
  }

  Future<List<String>> _fetchCategories() async {
    final result = await _repository.getAllJobTitles();
    return result.fold(
      (error) => ['All'], // Fallback
      (titles) {
        final categories = <String>{'All'};

        for (final title in titles) {
          // Simple extraction logic:
          // 1. Split by space
          // 2. Filter out common non-category words
          // 3. Add to set

          // Better approach for MVP: Use a predefined list of "Known Tech" and check if title contains it.
          // If we just split, we get "Senior", "Junior", "Developer" which are not categories.

          final knownCategories = [
            'Flutter',
            'React Native',
            'ReactJS',
            'NodeJS',
            'Node.js',
            'Java',
            'Python',
            'C#',
            '.NET',
            'PHP',
            'Laravel',
            'VueJS',
            'Angular',
            'Swift',
            'Kotlin',
            'Android',
            'iOS',
            'Tester',
            'QA',
            'QC',
            'Business Analyst',
            'BA',
            'Product Owner',
            'Project Manager',
            'Designer',
            'UI/UX',
            'Marketing',
            'Sales',
            'HR',
            'Accountant',
          ];

          for (final known in knownCategories) {
            if (title.toLowerCase().contains(known.toLowerCase())) {
              // Normalize Node.js -> NodeJS for consistency if needed, or keep as is.
              // Let's keep the known string format
              categories.add(known);
            }
          }
        }

        // If no known categories found in a title, maybe add the whole title? No, too messy.

        return categories.toList()..sort((a, b) {
          if (a == 'All') return -1;
          if (b == 'All') return 1;
          return a.compareTo(b);
        });
      },
    );
  }
}
