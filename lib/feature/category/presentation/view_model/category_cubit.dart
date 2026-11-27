import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:elrasheedy_dashboard/core/repos/upload_image_repo/upload_image_repo.dart';
import 'package:meta/meta.dart';

import '../../domain/repos/category_repo.dart';
import '../../domain/entities/category_entity.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepo _categoryRepo;
  final UploadImageRepo _uploadImageRepo;

  StreamSubscription<List<CategoryEntity>>? _categoriesSubscription;

  CategoryCubit(this._categoryRepo, this._uploadImageRepo)
      : super(CategoryInitial());

  List<CategoryEntity> categories = [];

  // ============================================================
  // GET CATEGORIES
  // ============================================================

  void getCategories() {
    // لو الـ Cubit اتقفل، متعملش أي حاجة
    if (isClosed) return;

    emit(CategoryGetLoading());

    // إلغاء الـ subscription القديمة
    _categoriesSubscription?.cancel();

    _categoriesSubscription =
        _categoryRepo.getCategoriesStream().listen(
              (categories) {
            // مهم جدًا:
            // ممكن الـ stream يرجع repos بعد ما Cubit يتقفل
            if (isClosed) return;

            this.categories = categories;

            emit(
              CategoryGetSuccess(
                categories: categories,
              ),
            );
          },
          onError: (error) {
            // ممكن يحصل error بعد إغلاق Cubit
            if (isClosed) return;

            emit(
              CategoryGetError(
                message: error.toString(),
              ),
            );
          },
        );
  }

  // ============================================================
  // ADD CATEGORY
  // ============================================================

  Future<void> addCategory(
      CategoryEntity category,
      File image,
      ) async {
    if (isClosed) return;

    emit(CategoryAddLoading());

    try {
      // ارفع الصورة الأول وبعدين ضيف القسم برابطها
      final result = await _uploadImageRepo.uploadImage(image);

      if (isClosed) return;

      await result.fold(
            (failure) async {
          emit(CategoryAddError(message: failure.errMessage));
        },
            (imageUrl) async {
          await _categoryRepo.addCategory(
            _withImage(category, imageUrl),
          );

          // مهم جدًا بعد await
          if (isClosed) return;

          emit(CategoryAddSuccess());
        },
      );
    } catch (e) {
      // لو Cubit اتقفل أثناء العملية
      if (isClosed) return;

      emit(
        CategoryAddError(
          message: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  /// ابعت newImage بس لو المستخدم اختار صورة جديدة،
  /// غير كده الصورة القديمة بتفضل زي ما هي.
  Future<void> updateCategory(
      CategoryEntity category, {
        File? newImage,
      }) async {
    if (isClosed) return;

    emit(CategoryUpdateLoading());

    try {
      if (newImage == null) {
        await _categoryRepo.updateCategory(category);

        // مهم جدًا بعد await
        if (isClosed) return;

        emit(CategoryUpdateSuccess());
        return;
      }

      final result = await _uploadImageRepo.uploadImage(newImage);

      if (isClosed) return;

      await result.fold(
            (failure) async {
          emit(CategoryUpdateError(message: failure.errMessage));
        },
            (imageUrl) async {
          await _categoryRepo.updateCategory(
            _withImage(category, imageUrl),
          );

          if (isClosed) return;

          emit(CategoryUpdateSuccess());
        },
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        CategoryUpdateError(
          message: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  Future<void> deleteCategory(
      String id,
      ) async {
    if (isClosed) return;

    emit(CategoryDeleteLoading());

    try {
      await _categoryRepo.deleteCategory(id);

      // مهم جدًا بعد await
      if (isClosed) return;

      emit(CategoryDeleteSuccess());
    } catch (e) {
      if (isClosed) return;

      emit(
        CategoryDeleteError(
          message: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // DELETE ALL CATEGORIES
  // ============================================================

  Future<void> deleteAllCategories() async {
    if (isClosed) return;

    emit(CategoryDeleteAllLoading());

    try {
      await _categoryRepo.deleteCollection(
        'categories',
      );

      // مهم جدًا بعد await
      if (isClosed) return;

      emit(CategoryDeleteAllSuccess());
    } catch (e) {
      if (isClosed) return;

      emit(
        CategoryDeleteAllError(
          message: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // UPDATE CATEGORIES ORDER
  // ============================================================

  Future<void> updateCategoriesOrder(
      List<CategoryEntity> categories,
      ) async {
    if (isClosed) return;

    try {
      await _categoryRepo.updateCategoriesOrder(
        categories,
      );

      // ممكن Cubit يتقفل أثناء await
      if (isClosed) return;

      this.categories = categories;
    } catch (e) {
      if (isClosed) return;

      emit(
        CategoryOrderUpdateError(
          message: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // CHECK CATEGORY EXISTS
  // ============================================================

  Future<bool> checkCategoryExists(
      String id,
      ) async {
    if (isClosed) return false;

    try {
      return await _categoryRepo.checkCategoryExists(id);
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  CategoryEntity _withImage(CategoryEntity category, String imageUrl) {
    return CategoryEntity(
      id: category.id,
      name: category.name,
      imageUrl: imageUrl,
      sizes: category.sizes,
      createdAt: category.createdAt,
      sortOrder: category.sortOrder,
    );
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  Future<void> close() async {
    // أوقف الـ stream أولًا
    await _categoriesSubscription?.cancel();

    _categoriesSubscription = null;

    // بعد كده اقفل Cubit
    return super.close();
  }
}