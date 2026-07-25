part of '../bloc/product_bloc.dart';

@immutable
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

/// Event to tell the BLoC to start listening to the product stream.
class ProductsSubscriptionRequested extends ProductEvent {
  const ProductsSubscriptionRequested();
}

/// Event to tell the BLoC to delete a product.
class ProductDeleted extends ProductEvent {
  const ProductDeleted(this.product);

  final Product product;

  @override
  List<Object> get props => [product];
}