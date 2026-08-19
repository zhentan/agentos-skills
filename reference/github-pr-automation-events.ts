export type GitHubPrAutomationSupportedEvent =
  | "pull_request"
  | "pull_request_review"
  | "pull_request_review_comment"
  | "issue_comment";

export type GitHubPrAutomationJobKind = "review" | "fix";

export interface GitHubPrAutomationDelivery {
  eventName: string;
  deliveryId: string;
  action: string;
  repository: string;
  actor: string;
  prNumber: number;
  prNodeId?: string;
  commentBody?: string;
}

export interface GitHubPrAutomationIntakeConfig {
  allowedRepositories: readonly string[];
  botActors?: readonly string[];
  continuationToken?: string;
}

export interface GitHubPrAutomationIntakeState {
  seenDeliveryIds: Set<string>;
}

export interface GitHubPrAutomationJob {
  kind: GitHubPrAutomationJobKind;
  repository: string;
  prNumber: number;
  prNodeId?: string;
  sourceEvent: GitHubPrAutomationSupportedEvent;
  sourceAction: string;
  sourceDeliveryId: string;
  actor: string;
  correlationId: string;
}

export type GitHubPrAutomationAuditDecision =
  | "accepted"
  | "duplicate_ignored"
  | "event_ignored"
  | "repo_ignored"
  | "bot_loop_ignored";

export interface GitHubPrAutomationAuditRecord {
  decision: GitHubPrAutomationAuditDecision;
  repository: string;
  prNumber: number;
  sourceEvent: string;
  sourceAction: string;
  sourceDeliveryId: string;
  actor: string;
  correlationId: string;
  reason: string;
}

export interface GitHubPrAutomationIntakeResult {
  jobs: GitHubPrAutomationJob[];
  audit: GitHubPrAutomationAuditRecord;
}

const SUPPORTED_EVENTS = new Set<string>([
  "pull_request",
  "pull_request_review",
  "pull_request_review_comment",
  "issue_comment",
]);

const REVIEW_PULL_REQUEST_ACTIONS = new Set([
  "opened",
  "reopened",
  "ready_for_review",
  "synchronize",
]);

export function intakeGitHubPrAutomationEvent(
  delivery: GitHubPrAutomationDelivery,
  config: GitHubPrAutomationIntakeConfig,
  state: GitHubPrAutomationIntakeState,
): GitHubPrAutomationIntakeResult {
  const correlationId = buildGitHubPrAutomationCorrelationId(delivery);

  if (state.seenDeliveryIds.has(delivery.deliveryId)) {
    return ignored(delivery, correlationId, "duplicate_ignored", "duplicate delivery id was already processed");
  }

  state.seenDeliveryIds.add(delivery.deliveryId);

  if (!isSupportedEvent(delivery.eventName)) {
    return ignored(delivery, correlationId, "event_ignored", "unsupported GitHub event type");
  }

  if (!config.allowedRepositories.includes(delivery.repository)) {
    return ignored(delivery, correlationId, "repo_ignored", "repository is not allowlisted for PR automation");
  }

  if (isBotLoop(delivery, config)) {
    return ignored(delivery, correlationId, "bot_loop_ignored", "bot actor did not provide the continuation token");
  }

  const kind = jobKindForDelivery(delivery);
  if (!kind) {
    return ignored(delivery, correlationId, "event_ignored", "GitHub event action is not configured for automation");
  }

  const job: GitHubPrAutomationJob = {
    kind,
    repository: delivery.repository,
    prNumber: delivery.prNumber,
    ...(delivery.prNodeId ? { prNodeId: delivery.prNodeId } : {}),
    sourceEvent: delivery.eventName,
    sourceAction: delivery.action,
    sourceDeliveryId: delivery.deliveryId,
    actor: delivery.actor,
    correlationId,
  };

  return {
    jobs: [job],
    audit: audit(delivery, correlationId, "accepted", "created normalized PR automation job"),
  };
}

export function buildGitHubPrAutomationCorrelationId(delivery: Pick<
  GitHubPrAutomationDelivery,
  "repository" | "prNumber" | "deliveryId"
>): string {
  return `github:${delivery.repository}#${delivery.prNumber}:${delivery.deliveryId}`;
}

function isSupportedEvent(eventName: string): eventName is GitHubPrAutomationSupportedEvent {
  return SUPPORTED_EVENTS.has(eventName);
}

function jobKindForDelivery(delivery: GitHubPrAutomationDelivery): GitHubPrAutomationJobKind | null {
  if (delivery.eventName === "pull_request") {
    return REVIEW_PULL_REQUEST_ACTIONS.has(delivery.action) ? "review" : null;
  }
  return "fix";
}

function isBotLoop(
  delivery: GitHubPrAutomationDelivery,
  config: GitHubPrAutomationIntakeConfig,
): boolean {
  if (!isBotActor(delivery.actor, config.botActors)) {
    return false;
  }

  const token = config.continuationToken?.trim();
  return !(token && delivery.commentBody?.includes(token));
}

function isBotActor(actor: string, configuredBotActors: readonly string[] | undefined): boolean {
  return actor.endsWith("[bot]") || configuredBotActors?.includes(actor) === true;
}

function ignored(
  delivery: GitHubPrAutomationDelivery,
  correlationId: string,
  decision: Exclude<GitHubPrAutomationAuditDecision, "accepted">,
  reason: string,
): GitHubPrAutomationIntakeResult {
  return {
    jobs: [],
    audit: audit(delivery, correlationId, decision, reason),
  };
}

function audit(
  delivery: GitHubPrAutomationDelivery,
  correlationId: string,
  decision: GitHubPrAutomationAuditDecision,
  reason: string,
): GitHubPrAutomationAuditRecord {
  return {
    decision,
    repository: delivery.repository,
    prNumber: delivery.prNumber,
    sourceEvent: delivery.eventName,
    sourceAction: delivery.action,
    sourceDeliveryId: delivery.deliveryId,
    actor: delivery.actor,
    correlationId,
    reason,
  };
}
