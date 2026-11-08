enum TransactionPhase { starting, inProgress, approved, failed }

extension TransactionPhaseX on TransactionPhase {
  bool get isBusy =>
      this == TransactionPhase.starting || this == TransactionPhase.inProgress;
}
