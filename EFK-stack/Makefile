apply-ns:
	@kubectl apply -f -ns.yaml
apply-sc:	
	@kubectl apply -f sc.yaml
apply-es-svc:	
	@kubectl apply -f elasticsearch.yaml
apply-es:	
	@kubectl apply -f elasticsearch-statefulset.yaml		
apply-kibana:	
	@kubectl apply -f kibana.yaml
apply-fluentd:
	@kubectl apply -f fluentd.yaml

destroy:
	@kubectl delete -f ns.yaml --force 	
