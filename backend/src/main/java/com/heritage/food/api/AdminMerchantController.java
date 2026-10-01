package com.heritage.food.api;

import com.heritage.food.dto.MerchantAdminWorkspaceResponse;
import com.heritage.food.model.MerchantProfile;
import com.heritage.food.service.MerchantService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/admin/merchants")
public class AdminMerchantController {

    private final MerchantService merchantService;

    public AdminMerchantController(MerchantService merchantService) {
        this.merchantService = merchantService;
    }

    @GetMapping("/workspace")
    public MerchantAdminWorkspaceResponse getWorkspace() {
        return merchantService.getAdminWorkspace();
    }

    @PutMapping("/accounts/{userId}/merchant-role")
    public void updateMerchantRole(@PathVariable Long userId, @RequestParam boolean enabled) {
        merchantService.updateMerchantRole(userId, enabled);
    }

    @PutMapping("/accounts/{userId}/profile")
    public MerchantProfile updateAccountProfile(@PathVariable Long userId, @RequestBody MerchantProfile profile) {
        return merchantService.updateAdminMerchantProfile(userId, profile);
    }

    @PutMapping("/onboarding/{id}/review")
    public void reviewOnboarding(@PathVariable Long id, @RequestParam boolean approved) {
        merchantService.reviewOnboarding(id, approved);
    }

    @PutMapping("/qualifications/{id}/review")
    public void reviewQualification(@PathVariable Long id, @RequestParam boolean approved) {
        merchantService.reviewQualification(id, approved);
    }

    @PutMapping("/settlements/{id}/status")
    public void updateSettlementStatus(@PathVariable Long id, @RequestParam String status) {
        merchantService.updateSettlementStatus(id, status);
    }

    @PutMapping("/withdrawals/{id}/status")
    public void updateWithdrawalStatus(@PathVariable Long id, @RequestParam String status) {
        merchantService.updateWithdrawalStatus(id, status);
    }

    @PutMapping("/products/{id}/status")
    public void updateProductStatus(@PathVariable Long id, @RequestParam String status) {
        merchantService.updateProductAuditStatus(id, status);
    }

    @PutMapping("/contents/{id}/status")
    public void updateContentStatus(@PathVariable Long id, @RequestParam String status) {
        merchantService.updateContentAuditStatus(id, status);
    }

    @PutMapping("/reviews/{id}/status")
    public void updateReviewStatus(@PathVariable Long id, @RequestParam String status) {
        merchantService.updateReviewAuditStatus(id, status);
    }

    @PutMapping("/artisans/{id}/status")
    public void updateArtisanStatus(@PathVariable Long id, @RequestParam String status) {
        merchantService.updateArtisanStatus(id, status);
    }

    @PostMapping("/sensitive-words")
    public void addSensitiveWord(@RequestBody Map<String, String> request) {
        merchantService.addSensitiveWord(request.getOrDefault("word", ""));
    }

    @DeleteMapping("/sensitive-words")
    public void deleteSensitiveWord(@RequestParam String word) {
        merchantService.deleteSensitiveWord(word);
    }
}
