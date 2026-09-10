# PP-AT: Paper Pseudocode

Companion to `PP_AT_manuscript.pdf`, uploaded on 2026-09-11. This is a readable description of the current protected progressive adaptive TTL mechanism, not executable MATLAB code. The PDF is a working manuscript.

## Notation

| Symbol | Meaning |
| --- | --- |
| j, s | Task and its discovering source robot |
| t, T | Current time and simulation horizon |
| h, H | Current task-message TTL and estimated ceiling |
| P, R, C, L | Normalized priority, resource demand, one-hop candidate sufficiency, and load imbalance |
| B_i, q_i, p_i | Reported busy-until time, resource, and position of robot i |
| q_j, p_j, E_j | Task resource requirement, position, and execution duration |
| v, c | Robot speed and state collection interval |
| W | Priority-dependent acceptable waiting time |

## Upper Bound

Use the source's one-hop neighborhood (including the source) for the initial estimate:

```text
P = clip(task.priority, 0, 1)
R = clip((q_j - resourceMin) / (resourceMax - resourceMin), 0, 1)
C = min(number of idle, resource-capable one-hop robots / N_ref, 1)
L = min(std(one-hop loads) / (mean(one-hop loads) + epsilon), 1)
H = clip(round(theta0 + thetaP*P + thetaR*R - thetaC*C + thetaL*L), 1, 5)
W = Wmax - (Wmax - Wmin)*P
```

The manuscript configuration uses theta = (1.7, 0.5, 0.4, 1.2, 0.3), N_ref = 2, Wmin = 10 s, and Wmax = 60 s. N_ref normalizes C; it is not a requirement for two immediately feasible robots.

## Algorithm 1: Progressive Communication Controller

```text
ON discovery of task j by source s at time t:
    Compute H and W from the initial task and one-hop state
    Set h = 1; initialize persistent incremental-flood state and report cache
    Propagate task information through incremental NetFlood at h
    Collect reachable robot-state reports; count TaskMSG and StateMSG
    Set nextDecision = t + 2*c

ON a scheduled controller decision while task j remains pending:
    If controller is done or t < nextDecision: return
    Record the source's own current state locally
    Refresh eligible stale remote reports (Algorithm 2)
    V = robots with valid, visible cached reports
    For each i in V:
        finish_i = max(B_i, t) + norm(p_i - p_j)/v + E_j
    F = {i in V: q_i >= q_j and finish_i <= T}
    I = {i in F: B_i <= t}

    If I is nonempty:
        Mark controller ready for the unchanged task allocator
        Stop this controller decision; readiness does not guarantee assignment
    Else:
        wait = min(max(B_i - t, 0) for i in F), or infinity if F is empty
        If wait <= W:
            Keep h; set nextDecision = t + max(c, wait)
        Else if h < H:
            Set h = h + 1
            Extend the existing incremental flood; do not restart it
            Collect additional reports and count all protocol messages
            Set nextDecision = t + 2*c
        Else:
            Mark controller max_reached
            Return control to the task lifecycle; do not mark task completed
```

## Algorithm 2: State Protection and Assignment Awareness

```text
BEFORE a controller decision:
    For each eligible remote cached robot report:
        If the report is visible, resource-capable, and at least 5 s old:
            Disseminate its refreshed state using NetFlood at current h
            Count the resulting StateMSG
            If the update reaches the source: replace its cached report
            Otherwise: invalidate its reported/visible membership

ON an accepted assignment of robot i to task k:
    Reuse the existing allocation dissemination (TTL = 2*h_k)
    For each pending task j whose source receives that dissemination:
        If j already has a report of i:
            Update reported busy-until time, load, and report time
            Update pending-task count when tracked
            Reactivate j's controller with nextDecision = t + c
    Do not add a duplicate allocation broadcast for awareness
```

## Implementation Boundaries

- Decisions after initialization use received cached reports, not unrestricted global robot states.
- Incremental flooding keeps propagation history; its reached set need not equal an instantaneous h-hop graph neighborhood after robots move.
- MSG = TaskMSG + StateMSG + AllocationMSG. Count transmitted link copies, including duplicate deliveries, with the same convention as the fixed-TTL baselines.
- The former service-margin forced-expansion rule and competition-triggered expansion are disabled. Protection here consists of state refresh and allocation-result awareness, together with the waiting/expansion controller.
- MPDM assignment and task execution remain separate from this communication controller. A ready or max_reached event is not a task-completion event.
- This document does not replace the full simulator event loop or claim guaranteed task completion.

Checked against: `computeAdaptiveTTL.m`, `initializeProgressiveAtController.m`, `advanceProgressiveAtController.m`, `evaluateReportedTaskState.m`, and `propagateProgressiveAssignmentAwareness.m` in the research project.
