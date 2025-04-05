import json
import statistics
from datetime import datetime

def load_timeline(file_path):
    with open(file_path) as f:
        return json.load(f)

def analyze_frame(frame):
    return {
        'duration': frame['duration'],
        'build': frame['build'],
        'raster': frame['raster']
    }

# Performance budgets in milliseconds
PERFORMANCE_BUDGETS = {
    'login_performance': {
        'duration': 1500,
        'build': 600,
        'raster': 500
    }
}

def compare_performance(current, baseline):
    report = []
    alerts = []
    
    for test_name in current:
        if test_name not in baseline:
            report.append(f"New test case: {test_name}")
            continue
            
        current_stats = analyze_frame(current[test_name])
        baseline_stats = analyze_frame(baseline[test_name])
        budget = PERFORMANCE_BUDGETS.get(test_name, {})
        
        report.append(f"\n## {test_name}")
        report.append("| Metric | Current | Baseline | Budget | Change | Status |")
        report.append("|--------|---------|----------|--------|--------|--------|")
        
        for metric in ['duration', 'build', 'raster']:
            curr = current_stats[metric]
            base = baseline_stats[metric]
            change = (curr - base) / base * 100
            budget_val = budget.get(metric, float('inf'))
            
            status = "✅"
            if curr > budget_val:
                status = "❌ OVER BUDGET"
                alerts.append(f"{test_name} {metric} exceeded budget: {curr:.0f}ms > {budget_val:.0f}ms")
            elif change > 10:  # 10% regression threshold
                status = "⚠️ REGRESSION"
                alerts.append(f"{test_name} {metric} regression: {change:+.2f}%")
            
            report.append(
                f"| {metric} | {curr:.2f}ms | {base:.2f}ms | "
                f"{budget_val:.0f}ms | {change:+.2f}% | {status} |"
            )
    
    if alerts:
        report.append("\n## 🚨 Performance Alerts")
        report.extend(alerts)
    
    return "\n".join(report)

if __name__ == "__main__":
    current = load_timeline("build/timeline_summary/current.json")
    baseline = load_timeline("performance_baseline.json")
    
    report = compare_performance(current, baseline)
    
    with open("performance_report.md", "w") as f:
        f.write(f"# Performance Report {datetime.now().date()}\n\n")
        f.write(report)
    
    print("Generated performance report")