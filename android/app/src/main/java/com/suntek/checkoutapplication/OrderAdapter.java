package com.suntek.checkoutapplication;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.text.DecimalFormat;
import java.util.List;

public class OrderAdapter extends RecyclerView.Adapter<OrderAdapter.OrderViewHolder> {

    private List<OrderItem> orderItems;
    private DecimalFormat decimalFormat = new DecimalFormat("$#,##0.00");

    public OrderAdapter(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    @NonNull
    @Override
    public OrderViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order, parent, false);
        return new OrderViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull OrderViewHolder holder, int position) {
        OrderItem item = orderItems.get(position);
        Product product = item.getProduct();
        holder.productName.setText(product.getName());
        holder.quantity.setText(String.valueOf(item.getQuantity()));
        holder.unitPrice.setText(decimalFormat.format(product.getPrice()));
        holder.totalPrice.setText(decimalFormat.format(item.getTotalPrice()));
    }

    @Override
    public int getItemCount() {
        return orderItems.size();
    }

    static class OrderViewHolder extends RecyclerView.ViewHolder {
        TextView productName;
        TextView quantity;
        TextView unitPrice;
        TextView totalPrice;

        public OrderViewHolder(@NonNull View itemView) {
            super(itemView);
            productName = itemView.findViewById(R.id.tv_order_item_name);
            quantity = itemView.findViewById(R.id.tv_order_item_quantity);
            unitPrice = itemView.findViewById(R.id.tv_order_item_price);
            totalPrice = itemView.findViewById(R.id.tv_order_item_total);
        }
    }
}