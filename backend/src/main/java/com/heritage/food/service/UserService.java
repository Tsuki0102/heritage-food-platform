package com.heritage.food.service;

import com.heritage.food.model.User;

import java.util.List;

public interface UserService {
    List<User> getAllUsers();
    User getUserById(Long id);
    User getUserByPhone(String phone);
    void saveUser(User user);
    void updateUser(User user);
    void deleteUser(Long id);
}