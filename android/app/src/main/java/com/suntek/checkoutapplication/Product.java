package com.suntek.checkoutapplication;

public class Product {
    private String id;
    private String name;
    private double price;
    private int imageResourceId;

    public Product(String id, String name, double price, int imageResourceId) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.imageResourceId = imageResourceId;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public double getPrice() {
        return price;
    }

    public int getImageResourceId() {
        return imageResourceId;
    }
}