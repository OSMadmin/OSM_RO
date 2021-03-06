/**
* Licensed under the Apache License, Version 2.0 (the "License"); you may
* not use this file except in compliance with the License. You may obtain
* a copy of the License at
*
*         http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations
* under the License.
**/
--
-- Adding different ingress and egress ports for SFC.
--

ALTER TABLE sce_rsp_hops
  DROP FOREIGN KEY FK_interfaces_rsp_hop,
  CHANGE COLUMN interface_id ingress_interface_id VARCHAR(36) NOT NULL
    AFTER if_order,
  ADD CONSTRAINT FK_interfaces_rsp_hop_ingress
    FOREIGN KEY (ingress_interface_id)
    REFERENCES interfaces (uuid) ON UPDATE CASCADE ON DELETE CASCADE,
  ADD COLUMN egress_interface_id VARCHAR(36) NULL DEFAULT NULL
    AFTER ingress_interface_id;

UPDATE sce_rsp_hops
  SET egress_interface_id = ingress_interface_id;

ALTER TABLE sce_rsp_hops
  ALTER COLUMN egress_interface_id DROP DEFAULT;

ALTER TABLE sce_rsp_hops
  MODIFY COLUMN egress_interface_id VARCHAR(36) NOT NULL
    AFTER ingress_interface_id,
  ADD CONSTRAINT FK_interfaces_rsp_hop_egress
    FOREIGN KEY (egress_interface_id)
    REFERENCES interfaces (uuid) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO schema_version (version_int, version, openmano_ver, comments, date)
  VALUES (35, '0.35', '0.6.02', 'Adding ingress and egress ports for RSPs', '2018-12-11');
