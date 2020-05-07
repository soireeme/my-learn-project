package com.soiree.springcloud.feignserver.controller;


import com.soiree.springcloud.feignserver.domain.CommonResult;
import com.soiree.springcloud.feignserver.domain.User;
import com.soiree.springcloud.feignserver.service.FeignService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
public class FeignController {
    @Resource
    private FeignService feignService;


    @GetMapping("/{id}")
    public CommonResult getUser(@PathVariable Long id) {
        return feignService.getUser(id);
    }

    @GetMapping("/getByUsername")
    public CommonResult getByUsername(@RequestParam String username) {
        return feignService.getByUsername(username);
    }

    @PostMapping("/create")
    public CommonResult create(@RequestBody User user) {
        return feignService.create(user);
    }

    @PostMapping("/update")
    public CommonResult update(@RequestBody User user) {
        return feignService.update(user);
    }

    @PostMapping("/delete/{id}")
    public CommonResult delete(@PathVariable Long id) {
        return feignService.delete(id);
    }


}