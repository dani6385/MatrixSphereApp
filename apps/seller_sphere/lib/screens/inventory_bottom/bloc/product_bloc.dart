import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:seller_sphere/services/product_service.dart';
import 'package:shared_services/shared_services.dart';

part '../product/product_event.dart';
part '../product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required ProductService productService})
      : _productService = productService,
        super(const ProductState()) {
    on<ProductsSubscriptionRequested>(_onSubscriptionRequested);
    on<ProductDeleted>(_onProductDeleted);
  }

  final ProductService _productService;

  Future<void> _onSubscriptionRequested(
    ProductsSubscriptionRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    await emit.onEach<List<Product>>(
      _productService.getProductsStream(),
      onData: (products) => emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
        ),
      ),
      onError: (error, stackTrace) => emit(
        state.copyWith(
          status: ProductStatus.failure,
          error: error.toString(),
        ),
      ),
    );
  }

  Future<void> _onProductDeleted(
    ProductDeleted event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await _productService.deleteProduct(event.product.id);
    } catch (e) {
      // Optionally, handle deletion error
      // For example, emit a failure state or show a snackbar
    }
  }
}