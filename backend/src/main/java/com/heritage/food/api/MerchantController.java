package com.heritage.food.api;

import com.heritage.food.dto.MerchantApplicationOverviewResponse;
import com.heritage.food.dto.MerchantWorkspaceResponse;
import com.heritage.food.model.MerchantContentSubmission;
import com.heritage.food.model.MerchantOnboardingApplication;
import com.heritage.food.model.MerchantProfile;
import com.heritage.food.model.MerchantProductSubmission;
import com.heritage.food.model.MerchantQualificationApplication;
import com.heritage.food.model.MerchantWithdrawal;
import com.heritage.food.service.MerchantService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/merchant")
public class MerchantController {

    private final MerchantService merchantService;

    public MerchantController(MerchantService merchantService) {
        this.merchantService = merchantService;
    }

    @GetMapping("/applications/overview")
    public MerchantApplicationOverviewResponse getApplicationOverview(@RequestParam(defaultValue = "3") Long userId) {
        return merchantService.getApplicationOverview(userId);
    }

    @PostMapping("/onboarding-applications")
    public MerchantOnboardingApplication submitOnboardingApplication(
            @RequestBody MerchantOnboardingApplication application,
            @RequestParam(defaultValue = "3") Long userId
    ) {
        return merchantService.submitOnboardingApplication(userId, application);
    }

    @GetMapping("/workspace")
    public MerchantWorkspaceResponse getWorkspace(@RequestParam(defaultValue = "3") Long userId, @RequestParam(defaultValue = "false") Boolean isAdmin) {
        return merchantService.getMerchantWorkspace(userId, isAdmin);
    }

    @PutMapping("/profile")
    public MerchantProfile saveProfile(@RequestBody MerchantProfile profile, @RequestParam(defaultValue = "3") Long userId, @RequestParam(defaultValue = "false") Boolean isAdmin) {
        return merchantService.saveMerchantProfile(userId, profile, isAdmin);
    }

    @PostMapping("/products")
    public MerchantProductSubmission saveProduct(@RequestBody MerchantProductSubmission submission, @RequestParam(defaultValue = "3") Long userId, @RequestParam(defaultValue = "false") Boolean isAdmin) {
        return merchantService.saveMerchantProduct(userId, submission, isAdmin);
    }

    @PutMapping("/products/{id}/status")
    public MerchantProductSubmission updateProductStatus(
            @PathVariable Long id,
            @RequestParam String status,
            @RequestParam(defaultValue = "3") Long userId,
            @RequestParam(defaultValue = "false") Boolean isAdmin
    ) {
        return merchantService.updateMerchantProductStatus(userId, id, status, isAdmin);
    }

    @PostMapping("/contents")
    public MerchantContentSubmission saveContent(@RequestBody MerchantContentSubmission submission, @RequestParam(defaultValue = "3") Long userId, @RequestParam(defaultValue = "false") Boolean isAdmin) {
        return merchantService.saveMerchantContent(userId, submission, isAdmin);
    }

    @PostMapping("/qualification-applications")
    public MerchantQualificationApplication submitQualificationApplication(
            @RequestBody MerchantQualificationApplication application,
            @RequestParam(defaultValue = "3") Long userId,
            @RequestParam(defaultValue = "false") Boolean isAdmin
    ) {
        return merchantService.submitQualificationApplication(userId, application, isAdmin);
    }

    @PostMapping("/withdrawals")
    public MerchantWithdrawal createWithdrawal(@RequestBody MerchantWithdrawal withdrawal, @RequestParam(defaultValue = "3") Long userId, @RequestParam(defaultValue = "false") Boolean isAdmin) {
        return merchantService.createMerchantWithdrawal(userId, withdrawal, isAdmin);
    }
}
