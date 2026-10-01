package com.heritage.food.api;

import com.heritage.food.model.User;
import com.heritage.food.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    @GetMapping("/{id}")
    public User getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    @GetMapping("/phone/{phone}")
    public User getUserByPhone(@PathVariable String phone) {
        return userService.getUserByPhone(phone);
    }

    @PostMapping
    public void saveUser(@RequestBody User user) {
        try {
            userService.saveUser(user);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @PutMapping
    public void updateUser(@RequestBody User user) {
        userService.updateUser(user);
    }

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
    }
}