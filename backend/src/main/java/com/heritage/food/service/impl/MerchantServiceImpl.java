package com.heritage.food.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.heritage.food.dao.MerchantArtisanMapper;
import com.heritage.food.dao.MerchantContentSubmissionMapper;
import com.heritage.food.dao.MerchantOnboardingApplicationMapper;
import com.heritage.food.dao.MerchantProductSubmissionMapper;
import com.heritage.food.dao.MerchantProfileMapper;
import com.heritage.food.dao.MerchantQualificationApplicationMapper;
import com.heritage.food.dao.MerchantReviewAuditMapper;
import com.heritage.food.dao.MerchantSensitiveWordMapper;
import com.heritage.food.dao.MerchantSettlementMapper;
import com.heritage.food.dao.MerchantWithdrawalMapper;
import com.heritage.food.dao.RoleMapper;
import com.heritage.food.dao.UserMapper;
import com.heritage.food.dao.UserRoleMapper;
import com.heritage.food.dto.MerchantAccountDto;
import com.heritage.food.dto.MerchantAdminWorkspaceResponse;
import com.heritage.food.dto.MerchantApplicationOverviewResponse;
import com.heritage.food.dto.MerchantReviewAuditDto;
import com.heritage.food.dto.MerchantWorkspaceResponse;
import com.heritage.food.model.MerchantArtisan;
import com.heritage.food.model.MerchantContentSubmission;
import com.heritage.food.model.MerchantOnboardingApplication;
import com.heritage.food.model.MerchantProductSubmission;
import com.heritage.food.model.MerchantProfile;
import com.heritage.food.model.MerchantQualificationApplication;
import com.heritage.food.model.MerchantReviewAudit;
import com.heritage.food.model.MerchantSensitiveWord;
import com.heritage.food.model.MerchantSettlement;
import com.heritage.food.model.MerchantWithdrawal;
import com.heritage.food.model.Role;
import com.heritage.food.model.User;
import com.heritage.food.model.UserRole;
import com.heritage.food.service.MerchantService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class MerchantServiceImpl implements MerchantService {

    private static final BigDecimal ZERO = BigDecimal.ZERO;

    private final MerchantProfileMapper merchantProfileMapper;
    private final MerchantProductSubmissionMapper merchantProductSubmissionMapper;
    private final MerchantContentSubmissionMapper merchantContentSubmissionMapper;
    private final MerchantSettlementMapper merchantSettlementMapper;
    private final MerchantWithdrawalMapper merchantWithdrawalMapper;
    private final MerchantOnboardingApplicationMapper merchantOnboardingApplicationMapper;
    private final MerchantQualificationApplicationMapper merchantQualificationApplicationMapper;
    private final MerchantReviewAuditMapper merchantReviewAuditMapper;
    private final MerchantArtisanMapper merchantArtisanMapper;
    private final MerchantSensitiveWordMapper merchantSensitiveWordMapper;
    private final UserMapper userMapper;
    private final RoleMapper roleMapper;
    private final UserRoleMapper userRoleMapper;

    public MerchantServiceImpl(
            MerchantProfileMapper merchantProfileMapper,
            MerchantProductSubmissionMapper merchantProductSubmissionMapper,
            MerchantContentSubmissionMapper merchantContentSubmissionMapper,
            MerchantSettlementMapper merchantSettlementMapper,
            MerchantWithdrawalMapper merchantWithdrawalMapper,
            MerchantOnboardingApplicationMapper merchantOnboardingApplicationMapper,
            MerchantQualificationApplicationMapper merchantQualificationApplicationMapper,
            MerchantReviewAuditMapper merchantReviewAuditMapper,
            MerchantArtisanMapper merchantArtisanMapper,
            MerchantSensitiveWordMapper merchantSensitiveWordMapper,
            UserMapper userMapper,
            RoleMapper roleMapper,
            UserRoleMapper userRoleMapper
    ) {
        this.merchantProfileMapper = merchantProfileMapper;
        this.merchantProductSubmissionMapper = merchantProductSubmissionMapper;
        this.merchantContentSubmissionMapper = merchantContentSubmissionMapper;
        this.merchantSettlementMapper = merchantSettlementMapper;
        this.merchantWithdrawalMapper = merchantWithdrawalMapper;
        this.merchantOnboardingApplicationMapper = merchantOnboardingApplicationMapper;
        this.merchantQualificationApplicationMapper = merchantQualificationApplicationMapper;
        this.merchantReviewAuditMapper = merchantReviewAuditMapper;
        this.merchantArtisanMapper = merchantArtisanMapper;
        this.merchantSensitiveWordMapper = merchantSensitiveWordMapper;
        this.userMapper = userMapper;
        this.roleMapper = roleMapper;
        this.userRoleMapper = userRoleMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public MerchantApplicationOverviewResponse getApplicationOverview(Long userId) {
        MerchantApplicationOverviewResponse response = new MerchantApplicationOverviewResponse();
        response.setOnboardingApplications(merchantOnboardingApplicationMapper.selectList(
                new QueryWrapper<MerchantOnboardingApplication>()
                        .eq("user_id", userId)
                        .orderByDesc("submitted_at", "id")));
        response.setQualificationApplications(merchantQualificationApplicationMapper.selectList(
                new QueryWrapper<MerchantQualificationApplication>()
                        .eq("user_id", userId)
                        .orderByDesc("submitted_at", "id")));
        return response;
    }

    @Override
    @Transactional
    public MerchantOnboardingApplication submitOnboardingApplication(Long userId, MerchantOnboardingApplication request) {
        if (hasMerchantRole(userId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "当前账号已经是商家");
        }

        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "用户不存在");
        }
        if (!StringUtils.hasText(request.getStoreName())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "店铺名称不能为空");
        }
        if (!StringUtils.hasText(request.getCategory())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "经营类目不能为空");
        }

        MerchantOnboardingApplication entity = merchantOnboardingApplicationMapper.selectOne(
                new QueryWrapper<MerchantOnboardingApplication>()
                        .eq("user_id", userId)
                        .eq("status", "pending")
                        .orderByDesc("submitted_at", "id")
                        .last("limit 1"));

        if (entity == null) {
            entity = new MerchantOnboardingApplication();
            entity.setUserId(userId);
            entity.setCreateTime(LocalDateTime.now());
        }

        entity.setApplicantName(StringUtils.hasText(request.getApplicantName()) ? request.getApplicantName().trim() : user.getNickname());
        entity.setPhone(user.getPhone());
        entity.setStoreName(request.getStoreName().trim());
        entity.setCategory(request.getCategory().trim());
        entity.setRegion(StringUtils.hasText(request.getRegion()) ? request.getRegion().trim() : null);
        entity.setNote(request.getNote() == null ? "" : request.getNote().trim());
        entity.setAttachmentUrls(trimOrDefault(request.getAttachmentUrls(), ""));
        entity.setStatus("pending");
        entity.setSubmittedAt(LocalDateTime.now());
        entity.setUpdateTime(LocalDateTime.now());

        if (entity.getId() == null) {
            merchantOnboardingApplicationMapper.insert(entity);
        } else {
            merchantOnboardingApplicationMapper.updateById(entity);
        }

        return merchantOnboardingApplicationMapper.selectById(entity.getId());
    }

    @Override
    @Transactional
    public MerchantWorkspaceResponse getMerchantWorkspace(Long userId, boolean isAdmin) {
        assertMerchantOrAdmin(userId, isAdmin);
        recalculateProfileAmounts(userId);

        MerchantWorkspaceResponse response = new MerchantWorkspaceResponse();
        response.setProfile(getOrCreateProfile(userId));
        response.setProducts(getMerchantProducts(userId));
        response.setContents(getMerchantContents(userId));
        response.setSettlements(getMerchantSettlements(userId));
        response.setWithdrawals(getMerchantWithdrawals(userId));
        return response;
    }

    @Override
    @Transactional
    public MerchantProfile saveMerchantProfile(Long userId, MerchantProfile request, boolean isAdmin) {
        assertMerchantOrAdmin(userId, isAdmin);

        MerchantProfile profile = getOrCreateProfile(userId);
        String previousStoreName = profile.getStoreName();

        if (StringUtils.hasText(request.getStoreName())) {
            profile.setStoreName(request.getStoreName().trim());
        }
        if (StringUtils.hasText(request.getStoreStatus())) {
            profile.setStoreStatus(request.getStoreStatus().trim());
        }
        if (request.getCommissionRate() != null) {
            profile.setCommissionRate(request.getCommissionRate());
        }
        if (request.getHeritageCertified() != null) {
            profile.setHeritageCertified(request.getHeritageCertified());
        }
        if (request.getContactName() != null) {
            profile.setContactName(request.getContactName().trim());
        }
        if (request.getContactPhone() != null) {
            profile.setContactPhone(request.getContactPhone().trim());
        }
        if (request.getIntroduction() != null) {
            profile.setIntroduction(request.getIntroduction().trim());
        }
        profile.setUpdateTime(LocalDateTime.now());
        merchantProfileMapper.updateById(profile);

        if (StringUtils.hasText(profile.getStoreName()) && !Objects.equals(previousStoreName, profile.getStoreName())) {
            syncMerchantName(userId, profile.getStoreName());
        }

        recalculateProfileAmounts(userId);
        return getOrCreateProfile(userId);
    }

    @Override
    @Transactional
    public MerchantProductSubmission saveMerchantProduct(Long userId, MerchantProductSubmission request, boolean isAdmin) {
        assertMerchantOrAdmin(userId, isAdmin);
        MerchantProfile profile = getOrCreateProfile(userId);
        MerchantProductSubmission entity;

        if (request.getId() != null) {
            entity = merchantProductSubmissionMapper.selectById(request.getId());
            if (entity == null) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "商家商品记录不存在");
            }
            if (!isAdmin && !userId.equals(entity.getUserId())) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "无权修改该商品记录");
            }
        } else {
            entity = new MerchantProductSubmission();
            entity.setUserId(userId);
            entity.setCreateTime(LocalDateTime.now());
        }

        entity.setMerchantName(profile.getStoreName());
        entity.setProductName(trimOrDefault(request.getProductName(), entity.getProductName()));
        entity.setCategory(trimOrDefault(request.getCategory(), entity.getCategory()));
        entity.setPrice(request.getPrice() == null ? ZERO : request.getPrice());
        entity.setHeritageTag(trimOrDefault(request.getHeritageTag(), entity.getHeritageTag()));
        entity.setDescription(trimOrDefault(request.getDescription(), entity.getDescription()));
        entity.setStatus("pending");
        entity.setSubmittedAt(LocalDateTime.now());
        entity.setUpdateTime(LocalDateTime.now());

        if (entity.getId() == null) {
            merchantProductSubmissionMapper.insert(entity);
        } else {
            merchantProductSubmissionMapper.updateById(entity);
        }

        return merchantProductSubmissionMapper.selectById(entity.getId());
    }

    @Override
    @Transactional
    public MerchantProductSubmission updateMerchantProductStatus(Long userId, Long submissionId, String status, boolean isAdmin) {
        assertMerchantOrAdmin(userId, isAdmin);
        MerchantProductSubmission entity = merchantProductSubmissionMapper.selectById(submissionId);

        if (entity == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "商家商品记录不存在");
        }
        if (!isAdmin && !userId.equals(entity.getUserId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "无权修改该商品记录");
        }

        entity.setStatus(status);
        entity.setSubmittedAt(LocalDateTime.now());
        entity.setUpdateTime(LocalDateTime.now());
        merchantProductSubmissionMapper.updateById(entity);
        return merchantProductSubmissionMapper.selectById(submissionId);
    }

    @Override
    @Transactional
    public MerchantContentSubmission saveMerchantContent(Long userId, MerchantContentSubmission request, boolean isAdmin) {
        assertMerchantOrAdmin(userId, isAdmin);
        MerchantProfile profile = getOrCreateProfile(userId);
        MerchantContentSubmission entity;

        if (request.getId() != null) {
            entity = merchantContentSubmissionMapper.selectById(request.getId());
            if (entity == null) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "商家内容记录不存在");
            }
            if (!isAdmin && !userId.equals(entity.getUserId())) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "无权修改该内容记录");
            }
        } else {
            entity = new MerchantContentSubmission();
            entity.setUserId(userId);
            entity.setCreateTime(LocalDateTime.now());
        }

        entity.setMerchantName(profile.getStoreName());
        entity.setTitle(trimOrDefault(request.getTitle(), entity.getTitle()));
        entity.setContentType(trimOrDefault(request.getContentType(), entity.getContentType()));
        entity.setRiskPoint(trimOrDefault(request.getRiskPoint(), entity.getRiskPoint()));
        entity.setContent(trimOrDefault(request.getContent(), entity.getContent()));
        entity.setStatus("pending");
        entity.setSubmittedAt(LocalDateTime.now());
        entity.setUpdateTime(LocalDateTime.now());

        if (entity.getId() == null) {
            merchantContentSubmissionMapper.insert(entity);
        } else {
            merchantContentSubmissionMapper.updateById(entity);
        }

        return merchantContentSubmissionMapper.selectById(entity.getId());
    }

    @Override
    @Transactional
    public MerchantQualificationApplication submitQualificationApplication(
            Long userId,
            MerchantQualificationApplication request,
            boolean isAdmin
    ) {
        assertMerchantOrAdmin(userId, isAdmin);

        if (!StringUtils.hasText(request.getProjectName())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "非遗项目不能为空");
        }

        MerchantProfile profile = getOrCreateProfile(userId);
        MerchantQualificationApplication entity = merchantQualificationApplicationMapper.selectOne(
                new QueryWrapper<MerchantQualificationApplication>()
                        .eq("user_id", userId)
                        .eq("status", "pending")
                        .orderByDesc("submitted_at", "id")
                        .last("limit 1"));

        if (entity == null) {
            entity = new MerchantQualificationApplication();
            entity.setUserId(userId);
            entity.setCreateTime(LocalDateTime.now());
        }

        entity.setMerchantName(profile.getStoreName());
        entity.setProjectName(request.getProjectName().trim());
        entity.setCertificateNo(trimOrDefault(request.getCertificateNo(), ""));
        entity.setIssuer(trimOrDefault(request.getIssuer(), ""));
        entity.setNote(trimOrDefault(request.getNote(), ""));
        entity.setAttachmentUrls(trimOrDefault(request.getAttachmentUrls(), ""));
        entity.setStatus("pending");
        entity.setSubmittedAt(LocalDateTime.now());
        entity.setUpdateTime(LocalDateTime.now());

        if (entity.getId() == null) {
            merchantQualificationApplicationMapper.insert(entity);
        } else {
            merchantQualificationApplicationMapper.updateById(entity);
        }

        return merchantQualificationApplicationMapper.selectById(entity.getId());
    }

    @Override
    @Transactional
    public MerchantWithdrawal createMerchantWithdrawal(Long userId, MerchantWithdrawal request, boolean isAdmin) {
        assertMerchantOrAdmin(userId, isAdmin);
        MerchantProfile profile = getOrCreateProfile(userId);

        MerchantWithdrawal entity = new MerchantWithdrawal();
        entity.setUserId(userId);
        entity.setMerchantName(profile.getStoreName());
        entity.setAmount(request.getAmount() == null ? ZERO : request.getAmount());
        entity.setAccountName(trimOrDefault(request.getAccountName(), profile.getContactName()));
        entity.setAccountNo(trimOrDefault(request.getAccountNo(), ""));
        entity.setStatus("pending");
        entity.setSubmittedAt(LocalDateTime.now());
        entity.setCreateTime(LocalDateTime.now());
        entity.setUpdateTime(LocalDateTime.now());
        merchantWithdrawalMapper.insert(entity);

        recalculateProfileAmounts(userId);
        return merchantWithdrawalMapper.selectById(entity.getId());
    }

    @Override
    @Transactional
    public MerchantAdminWorkspaceResponse getAdminWorkspace() {
        MerchantAdminWorkspaceResponse response = new MerchantAdminWorkspaceResponse();
        response.setAccounts(buildAccountDtos());
        response.setOnboardingApplications(merchantOnboardingApplicationMapper.selectList(
                new QueryWrapper<MerchantOnboardingApplication>().orderByDesc("submitted_at", "id")));
        response.setQualificationApplications(merchantQualificationApplicationMapper.selectList(
                new QueryWrapper<MerchantQualificationApplication>().orderByDesc("submitted_at", "id")));
        response.setSettlementRecords(merchantSettlementMapper.selectList(
                new QueryWrapper<MerchantSettlement>().orderByDesc("create_time", "id")));
        response.setWithdrawRequests(merchantWithdrawalMapper.selectList(
                new QueryWrapper<MerchantWithdrawal>().orderByDesc("submitted_at", "id")));
        response.setProductAudits(merchantProductSubmissionMapper.selectList(
                new QueryWrapper<MerchantProductSubmission>().orderByDesc("submitted_at", "id")));
        response.setContentAudits(merchantContentSubmissionMapper.selectList(
                new QueryWrapper<MerchantContentSubmission>().orderByDesc("submitted_at", "id")));
        response.setReviewAudits(merchantReviewAuditMapper.selectList(
                        new QueryWrapper<MerchantReviewAudit>().orderByDesc("submitted_at", "id"))
                .stream()
                .map(this::toReviewAuditDto)
                .collect(Collectors.toList()));
        response.setArtisanRecords(merchantArtisanMapper.selectList(
                new QueryWrapper<MerchantArtisan>().orderByDesc("create_time", "id")));
        response.setSensitiveWords(merchantSensitiveWordMapper.selectList(
                        new QueryWrapper<MerchantSensitiveWord>().orderByDesc("id"))
                .stream()
                .map(MerchantSensitiveWord::getWord)
                .filter(StringUtils::hasText)
                .collect(Collectors.toList()));
        return response;
    }

    @Override
    @Transactional
    public void updateMerchantRole(Long userId, boolean enabled) {
        Role merchantRole = getMerchantRole();
        if (merchantRole == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "商家角色不存在");
        }

        QueryWrapper<UserRole> wrapper = new QueryWrapper<UserRole>()
                .eq("user_id", userId)
                .eq("role_id", merchantRole.getId());
        UserRole relation = userRoleMapper.selectOne(wrapper);

        if (enabled && relation == null) {
            UserRole userRole = new UserRole();
            userRole.setUserId(userId);
            userRole.setRoleId(merchantRole.getId());
            userRole.setCreateTime(new Date());
            userRoleMapper.insert(userRole);
        }

        if (!enabled && relation != null) {
            userRoleMapper.deleteById(relation.getId());
            MerchantProfile profile = getOrCreateProfile(userId);
            profile.setStoreStatus("limited");
            profile.setUpdateTime(LocalDateTime.now());
            merchantProfileMapper.updateById(profile);
        }
    }

    @Override
    @Transactional
    public MerchantProfile updateAdminMerchantProfile(Long userId, MerchantProfile request) {
        return saveMerchantProfile(userId, request, true);
    }

    @Override
    @Transactional
    public void reviewOnboarding(Long id, boolean approved) {
        MerchantOnboardingApplication application = merchantOnboardingApplicationMapper.selectById(id);
        if (application == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "商家入驻申请不存在");
        }

        application.setStatus(approved ? "approved" : "rejected");
        application.setUpdateTime(LocalDateTime.now());
        merchantOnboardingApplicationMapper.updateById(application);

        if (!approved) {
            return;
        }

        User user = userMapper.selectOne(new QueryWrapper<User>()
                .eq("phone", application.getPhone())
                .last("limit 1"));
        if (user == null) {
            return;
        }

        updateMerchantRole(user.getId(), true);
        MerchantProfile profile = new MerchantProfile();
        profile.setStoreName(application.getStoreName());
        profile.setStoreStatus("active");
        profile.setContactName(application.getApplicantName());
        profile.setContactPhone(application.getPhone());
        saveMerchantProfile(user.getId(), profile, true);
    }

    @Override
    @Transactional
    public void reviewQualification(Long id, boolean approved) {
        MerchantQualificationApplication application = merchantQualificationApplicationMapper.selectById(id);
        if (application == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "非遗资质申请不存在");
        }

        application.setStatus(approved ? "approved" : "rejected");
        application.setUpdateTime(LocalDateTime.now());
        merchantQualificationApplicationMapper.updateById(application);

        if (approved && application.getUserId() != null) {
            MerchantProfile profile = new MerchantProfile();
            profile.setHeritageCertified(true);
            saveMerchantProfile(application.getUserId(), profile, true);
        }
    }

    @Override
    @Transactional
    public void updateSettlementStatus(Long id, String status) {
        MerchantSettlement settlement = merchantSettlementMapper.selectById(id);
        if (settlement == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "结算记录不存在");
        }

        settlement.setStatus(status);
        settlement.setUpdateTime(LocalDateTime.now());
        merchantSettlementMapper.updateById(settlement);

        if ("paid".equalsIgnoreCase(status)) {
            MerchantProfile profile = getOrCreateProfile(settlement.getUserId());
            profile.setLastSettlementAt(LocalDateTime.now());
            profile.setUpdateTime(LocalDateTime.now());
            merchantProfileMapper.updateById(profile);
        }

        recalculateProfileAmounts(settlement.getUserId());
    }

    @Override
    @Transactional
    public void updateWithdrawalStatus(Long id, String status) {
        MerchantWithdrawal withdrawal = merchantWithdrawalMapper.selectById(id);
        if (withdrawal == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "提现记录不存在");
        }

        withdrawal.setStatus(status);
        withdrawal.setUpdateTime(LocalDateTime.now());
        merchantWithdrawalMapper.updateById(withdrawal);
        recalculateProfileAmounts(withdrawal.getUserId());
    }

    @Override
    @Transactional
    public void updateProductAuditStatus(Long id, String status) {
        MerchantProductSubmission submission = merchantProductSubmissionMapper.selectById(id);
        if (submission == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "商品审核记录不存在");
        }

        submission.setStatus(status);
        submission.setUpdateTime(LocalDateTime.now());
        merchantProductSubmissionMapper.updateById(submission);
    }

    @Override
    @Transactional
    public void updateContentAuditStatus(Long id, String status) {
        MerchantContentSubmission submission = merchantContentSubmissionMapper.selectById(id);
        if (submission == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "内容审核记录不存在");
        }

        submission.setStatus(status);
        submission.setUpdateTime(LocalDateTime.now());
        merchantContentSubmissionMapper.updateById(submission);
    }

    @Override
    @Transactional
    public void updateReviewAuditStatus(Long id, String status) {
        MerchantReviewAudit reviewAudit = merchantReviewAuditMapper.selectById(id);
        if (reviewAudit == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "评价审核记录不存在");
        }

        reviewAudit.setStatus(status);
        reviewAudit.setUpdateTime(LocalDateTime.now());
        merchantReviewAuditMapper.updateById(reviewAudit);
    }

    @Override
    @Transactional
    public void updateArtisanStatus(Long id, String status) {
        MerchantArtisan artisan = merchantArtisanMapper.selectById(id);
        if (artisan == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "匠人记录不存在");
        }

        artisan.setStatus(status);
        artisan.setUpdateTime(LocalDateTime.now());
        merchantArtisanMapper.updateById(artisan);
    }

    @Override
    @Transactional
    public void addSensitiveWord(String word) {
        if (!StringUtils.hasText(word)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "敏感词不能为空");
        }

        String normalized = word.trim();
        MerchantSensitiveWord existing = merchantSensitiveWordMapper.selectOne(new QueryWrapper<MerchantSensitiveWord>()
                .eq("word", normalized)
                .last("limit 1"));
        if (existing != null) {
            return;
        }

        MerchantSensitiveWord sensitiveWord = new MerchantSensitiveWord();
        sensitiveWord.setWord(normalized);
        sensitiveWord.setCreateTime(LocalDateTime.now());
        sensitiveWord.setUpdateTime(LocalDateTime.now());
        merchantSensitiveWordMapper.insert(sensitiveWord);
    }

    @Override
    @Transactional
    public void deleteSensitiveWord(String word) {
        if (!StringUtils.hasText(word)) {
            return;
        }
        merchantSensitiveWordMapper.delete(new QueryWrapper<MerchantSensitiveWord>().eq("word", word.trim()));
    }

    private void assertMerchantOrAdmin(Long userId, boolean isAdmin) {
        if (isAdmin) {
            return;
        }
        if (!hasMerchantRole(userId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "当前账号不是商家角色");
        }
    }

    private boolean hasMerchantRole(Long userId) {
        return roleMapper.selectRolesByUserId(userId).stream()
                .anyMatch(role -> "merchant".equals(role.getRoleKey()));
    }

    private Role getMerchantRole() {
        return roleMapper.selectOne(new QueryWrapper<Role>()
                .eq("role_key", "merchant")
                .last("limit 1"));
    }

    private MerchantProfile getOrCreateProfile(Long userId) {
        MerchantProfile profile = merchantProfileMapper.selectOne(new QueryWrapper<MerchantProfile>()
                .eq("user_id", userId)
                .last("limit 1"));
        if (profile != null) {
            return profile;
        }

        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "用户不存在");
        }

        profile = new MerchantProfile();
        profile.setUserId(userId);
        profile.setStoreName(user.getNickname() + "的非遗小店");
        profile.setStoreStatus("active");
        profile.setCommissionRate(new BigDecimal("12.00"));
        profile.setHeritageCertified(false);
        profile.setSettlementAmount(ZERO);
        profile.setWithdrawPending(ZERO);
        profile.setContactName(user.getNickname());
        profile.setContactPhone(user.getPhone());
        profile.setIntroduction("这里是商家的品牌介绍，可展示非遗技艺、匠人故事和门店特色。");
        profile.setCreateTime(LocalDateTime.now());
        profile.setUpdateTime(LocalDateTime.now());
        merchantProfileMapper.insert(profile);
        return profile;
    }

    private List<MerchantProductSubmission> getMerchantProducts(Long userId) {
        return merchantProductSubmissionMapper.selectList(new QueryWrapper<MerchantProductSubmission>()
                .eq("user_id", userId)
                .orderByDesc("submitted_at", "id"));
    }

    private List<MerchantContentSubmission> getMerchantContents(Long userId) {
        return merchantContentSubmissionMapper.selectList(new QueryWrapper<MerchantContentSubmission>()
                .eq("user_id", userId)
                .orderByDesc("submitted_at", "id"));
    }

    private List<MerchantSettlement> getMerchantSettlements(Long userId) {
        return merchantSettlementMapper.selectList(new QueryWrapper<MerchantSettlement>()
                .eq("user_id", userId)
                .orderByDesc("create_time", "id"));
    }

    private List<MerchantWithdrawal> getMerchantWithdrawals(Long userId) {
        return merchantWithdrawalMapper.selectList(new QueryWrapper<MerchantWithdrawal>()
                .eq("user_id", userId)
                .orderByDesc("submitted_at", "id"));
    }

    private void syncMerchantName(Long userId, String storeName) {
        merchantProductSubmissionMapper.update(null, new UpdateWrapper<MerchantProductSubmission>()
                .eq("user_id", userId)
                .set("merchant_name", storeName));
        merchantContentSubmissionMapper.update(null, new UpdateWrapper<MerchantContentSubmission>()
                .eq("user_id", userId)
                .set("merchant_name", storeName));
        merchantSettlementMapper.update(null, new UpdateWrapper<MerchantSettlement>()
                .eq("user_id", userId)
                .set("merchant_name", storeName));
        merchantWithdrawalMapper.update(null, new UpdateWrapper<MerchantWithdrawal>()
                .eq("user_id", userId)
                .set("merchant_name", storeName));
        merchantQualificationApplicationMapper.update(null, new UpdateWrapper<MerchantQualificationApplication>()
                .eq("user_id", userId)
                .set("merchant_name", storeName));
        merchantReviewAuditMapper.update(null, new UpdateWrapper<MerchantReviewAudit>()
                .eq("user_id", userId)
                .set("merchant_name", storeName));
        merchantArtisanMapper.update(null, new UpdateWrapper<MerchantArtisan>()
                .eq("user_id", userId)
                .set("merchant_name", storeName));
    }

    private void recalculateProfileAmounts(Long userId) {
        MerchantProfile profile = getOrCreateProfile(userId);

        BigDecimal settlementAmount = merchantSettlementMapper.selectList(new QueryWrapper<MerchantSettlement>()
                        .eq("user_id", userId)
                        .ne("status", "paid"))
                .stream()
                .map(MerchantSettlement::getPayableAmount)
                .filter(Objects::nonNull)
                .reduce(ZERO, BigDecimal::add);

        BigDecimal withdrawPending = merchantWithdrawalMapper.selectList(new QueryWrapper<MerchantWithdrawal>()
                        .eq("user_id", userId)
                        .eq("status", "pending"))
                .stream()
                .map(MerchantWithdrawal::getAmount)
                .filter(Objects::nonNull)
                .reduce(ZERO, BigDecimal::add);

        MerchantSettlement latestPaid = merchantSettlementMapper.selectOne(new QueryWrapper<MerchantSettlement>()
                .eq("user_id", userId)
                .eq("status", "paid")
                .orderByDesc("update_time")
                .last("limit 1"));

        profile.setSettlementAmount(settlementAmount);
        profile.setWithdrawPending(withdrawPending);
        profile.setLastSettlementAt(latestPaid == null ? null : latestPaid.getUpdateTime());
        profile.setUpdateTime(LocalDateTime.now());
        merchantProfileMapper.updateById(profile);
    }

    private List<MerchantAccountDto> buildAccountDtos() {
        List<User> users = userMapper.selectList(new QueryWrapper<User>().orderByAsc("id"));
        List<MerchantAccountDto> accounts = new ArrayList<>();

        for (User user : users) {
            List<Role> roles = roleMapper.selectRolesByUserId(user.getId());
            List<String> roleKeys = roles.stream().map(Role::getRoleKey).collect(Collectors.toList());
            boolean isMerchant = roleKeys.contains("merchant");

            MerchantProfile profile = merchantProfileMapper.selectOne(new QueryWrapper<MerchantProfile>()
                    .eq("user_id", user.getId())
                    .last("limit 1"));
            if (profile == null && isMerchant) {
                profile = getOrCreateProfile(user.getId());
            }

            MerchantAccountDto account = new MerchantAccountDto();
            account.setId(user.getId());
            account.setNickname(user.getNickname());
            account.setPhone(user.getPhone());
            account.setAvatar(user.getAvatar());
            account.setGender(user.getGender());
            account.setRegion(user.getRegion());
            account.setStatus(user.getStatus());
            account.setIsAdmin(user.getIsAdmin());
            account.setRoleIds(roles.stream().map(Role::getId).collect(Collectors.toList()));
            account.setRoleKeys(roleKeys);
            account.setRoleNames(roles.stream().map(Role::getRoleName).collect(Collectors.toList()));
            account.setIsMerchant(isMerchant);

            if (profile != null) {
                account.setStoreName(profile.getStoreName());
                account.setStoreStatus(profile.getStoreStatus());
                account.setCommissionRate(profile.getCommissionRate());
                account.setHeritageCertified(profile.getHeritageCertified());
                account.setSettlementAmount(profile.getSettlementAmount());
                account.setWithdrawPending(profile.getWithdrawPending());
                account.setLastSettlementAt(profile.getLastSettlementAt());
                account.setContactName(profile.getContactName());
                account.setContactPhone(profile.getContactPhone());
                account.setIntroduction(profile.getIntroduction());
            } else {
                account.setStoreName("");
                account.setStoreStatus("limited");
                account.setCommissionRate(new BigDecimal("8.00"));
                account.setHeritageCertified(false);
                account.setSettlementAmount(ZERO);
                account.setWithdrawPending(ZERO);
                account.setLastSettlementAt(null);
                account.setContactName(user.getNickname());
                account.setContactPhone(user.getPhone());
                account.setIntroduction("");
            }

            accounts.add(account);
        }

        accounts.sort(Comparator.comparing(MerchantAccountDto::getIsMerchant).reversed()
                .thenComparing(MerchantAccountDto::getId));
        return accounts;
    }

    private MerchantReviewAuditDto toReviewAuditDto(MerchantReviewAudit reviewAudit) {
        MerchantReviewAuditDto dto = new MerchantReviewAuditDto();
        dto.setId(reviewAudit.getId());
        dto.setUserName(reviewAudit.getUserName());
        dto.setMerchantName(reviewAudit.getMerchantName());
        dto.setContent(reviewAudit.getContent());
        dto.setSubmittedAt(reviewAudit.getSubmittedAt());
        dto.setStatus(reviewAudit.getStatus());

        if (StringUtils.hasText(reviewAudit.getHitWords())) {
            dto.setHitWords(List.of(reviewAudit.getHitWords().split("\\s*,\\s*")));
        } else {
            dto.setHitWords(List.of());
        }

        return dto;
    }

    private String trimOrDefault(String value, String fallback) {
        return StringUtils.hasText(value) ? value.trim() : fallback;
    }
}
